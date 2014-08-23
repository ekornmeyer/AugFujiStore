module OrderLinesHelper

def update_order

  @get_order = HTTParty.get("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{session[:cookies_orderid]}",
      :headers => { "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })

HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/" + session[:cookies_orderid],
            :body => 
            {"Lines" =>
            @db_lines.map do |line|
             {
               :ProductCode => line.ProductCode,
               :Quantity => line.Quantity,
               :UnitPrice => line.UnitPrice,
               :Pages =>
               [
                  {
                    :PageNumber => line.PageNumber,
                    :Assets =>
                    [
                      { 
                        :AssetNumber => line.AssetNumber,
                        :Name => line.Name,
                        :HiResImage => line.HiResImage, 
                        :CropMode => line.CropMode
                      }
                    ]
                  }
               ]
            } 
          end}.to_json,
      :headers => { "Content-Type" => "application/json",
                    "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })

	  @get_lines = HTTParty.get("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}/lines?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa")
	  y = -1
	  @get_lines['Lines'].each do |fline|
	  	y += 1
	    @db_lines[y].update_column(:preview_url, fline['LinePreviewThumbnail'])
	end
end

end
