class HomeController < ApplicationController
  
  def test_connectivity
    respond_to do |fromat|
      # unrequired onversion of hash to json, when rendering as json
      # Fixed
      fromat.json { render json: {status: "true", message: "API working fine."}}
    end
  end
end
