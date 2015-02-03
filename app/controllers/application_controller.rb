class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #before_filter :restrict_access
  
  #  curl --basic --header "Content-Type:application/json" --header "Accept:application/json" http://localhost:3000/test_connectivity -H 'Authorization: Token id="96e7b2cc9c7db23f41cc700d13fc6f03", secret="551315ccf9372f318dad7c5c696cd1481"' -X GET
  
  private

    def restrict_access
      authenticate_or_request_with_http_token do |id, secret, options|
        id == "id" && secret[:secret] == "sec"
      end
    end
    
    protected
    def request_http_token_authentication(realm = "Application")
      self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")})
      render :json => {status: "false", message: "HTTP Token: Access denied."}, status: :unauthorized
    end 
end
