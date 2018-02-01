class ItemsController < ApplicationController
  before_action :require_user_logged_in

  def new
    @items = []

    @keyword = params[:keyword]
    if @keyword.present?  
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
        #扱いやすいようにItemとしてインスタンスを作成する(保存はしない)
      results.each do |result|
        item = Item.find_or_initialize_by(read(result))
        @items << item #itemに[]を追加
      end
    end
  end

  private

  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')

    return {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end