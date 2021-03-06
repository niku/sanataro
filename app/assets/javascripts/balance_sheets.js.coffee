$ () ->
  global = document
  urls = global.urls
  $.ajax {
    url: urls["asset"],
    type: "GET",
    dataType: "json",
    success: (data) -> pieChart "#asset_chart", data }
  $.ajax {
    url: urls["debt"],
    type: "GET",
    dataType: "json",
    success: (data) -> pieChart "#debt_chart", data }
  $.ajax {
    url: urls["yearly_asset"],
    type: "GET",
    dataType: "json",
    success: (data) -> lineChart "#yearly_chart", "#yearly_chart_choices" , data }

