# coding: utf-8
class Api::YearlyAssetsController < ApplicationController
  respond_to :json

  before_filter :required_login
  before_filter :_redirect_if_invalid_year_month!

  def show
    year, month = CommonUtil.get_year_month_from_combined(params[:id])
    date_to = Date.new(year.to_i, month.to_i)
    date_since = date_to.months_ago(11)
    accounts = @user.accounts.where(account_type: "account").order(:order_no)
    respond_with _json_assets(accounts, date_since)
  end
  
  private
  def _redirect_if_invalid_year_month!
    unless CommonUtil.valid_combined_year_month?(params[:id])
      redirect_to login_url
      return false
    end
    true
  end

  def _json_assets(accounts, date_since)
    results = accounts.inject({}) { |data, a|
      data["account_#{a.id}"] = { "label" => a.name, "data" => _json_account_assets(a.id, date_since)}
      data
    }

    results["total"] = { label: I18n.t("label.total"),
      data: _json_total_assets(accounts.map(&:id), date_since) }

    results
  end
  
  def _json_account_assets(account_id, date_since)
    json_data = []
    (0..11).inject(Account.asset_of_month(@user, account_id, date_since.months_ago(1))) do |amount, i|
      month = date_since.months_since(i)
      mpl = @user.monthly_profit_losses.where(account_id: account_id, month: month).first
      amount += mpl ? mpl.amount : 0
      json_data << [json_date_format(month), amount]
      amount
    end
    json_data
  end
  
  def _json_total_assets(account_ids, date_since)
    initial_total = Account.asset_of_month(@user, account_ids, date_since.months_ago(1))
    ignored, data = (0..11).inject([initial_total, []]) do |total_data, i|
      total = total_data[0]
      data = total_data[1]
      month = date_since.months_since(i)
      total += MonthlyProfitLoss.where(account_id: account_ids, month: month).sum(:amount)
      data << [json_date_format(month), total]
      [total, data]
    end
    data
  end
end
