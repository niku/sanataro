# -*- coding: utf-8 -*-
user = User.create!(login: "demo",
                    password_plain: "demo123", password_confirmation: "demo123",
                    email: "sample@example.com",
                    active: true)

hashed_accounts = [{name: "財布", order_no: 10, type: 'account'},
                   {name: "銀行A", order_no: 20, type: 'account'},
                   {name: "銀行B", order_no: 30, type: 'account'},
                   {name: "クレジットカード", order_no: 30, type: 'account'},
                   {name: "給与", order_no: 10, type: 'income'},
                   {name: "賞与", order_no: 20, type: 'income'},
                   {name: "雑収入", order_no: 30, type: 'income'},
                   {name: "食費", order_no: 10, type: 'outgo'},
                   {name: "光熱費", order_no: 10, type: 'outgo'},
                   {name: "住居費", order_no: 10, type: 'outgo'},
                   {name: "美容費", order_no: 10, type: 'outgo'},
                   {name: "衛生費", order_no: 10, type: 'outgo'},
                   {name: "雑費", order_no: 10, type: 'outgo'},
                  ]

accounts = []
hashed_accounts.each do |data|
  accounts << user.accounts.create!(name: data[:name], order_no: data[:order_no],
                                    account_type: data[:type])
end

user.credit_relations.create!(credit_account_id: accounts.find{|a| a.name == "クレジットカード" }.id,
                              payment_account_id: accounts.find{|a| a.name == "銀行B" }.id,
                              settlement_day: 25, payment_month: 2, payment_day: 4)

user.items.create!(name: '会社給与',
                   from_account_id: accounts.find{ |a| a.name == "給与"}.id,
                   to_account_id: accounts.find{|a| a.name == "銀行A" }.id,
                   amount: 1000, action_date: Date.today)

user.items.create!(name: '妻のへそくりを発見',
                   from_account_id: accounts.find{ |a| a.name == "雑収入"}.id,
                   to_account_id: accounts.find{|a| a.name == "財布" }.id,
                   amount: 800, action_date: Date.yesterday, confirmation_required: true)

user.items.create!(name: 'サンプル支出',
                   from_account_id: accounts.find{|a| a.name == "財布" }.id,
                   to_account_id: accounts.find{|a| a.name == "食費" }.id,
                   amount: 250, action_date: Date.today, tag_list: 'コンビニ')

