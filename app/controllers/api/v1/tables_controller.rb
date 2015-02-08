class Api::V1::TablesController < ApplicationController
  before_action :set_table

  # GET /tables.json
  #curl --basic --header "Content-Type:application/jsonalhost:3000/api/v1/tables -H 'Authorization: Token id="id", secret="sec"' -X GET
  def index
    tables = @connection.tables
    data = {message: "Listing tables in database", data: tables}
    render :json => {status: 200, data: data}
  end
  
  # DELETE /tables/1
  #curl --basic --header Content-Type:application/json http://localhost:3000/api/v1/tables/users1 -H 'Authorization: Token id="id", secret="sec"' -X DELETE
  def destroy
    unless @connection.tables.include?(params[:id])
      status = 403
      data = {message: "Table doesn't exist"}
    else
      res = @connection.execute("DROP TABLE #{params[:id]};") 
      status = 200
      data = {message: "Table dropped successfully"}
    end
    render :json => {status: status, data: data}
  end

  # GET /tables/1
  # GET /tables/1.json
  #  curl --basic --header Content-Type:application/json http://localhost:3000/api/v1/tables/users1 -H 'Authorization: Token id="id", secret="sec"' -X GET
  def show
    rows = []
    unless @connection.tables.include?(params[:id])
      status = 403
      data = {message: "Table doesn't exist"}
    else
      res = @connection.execute("DESC #{params[:id]};") 
      status = 200
      data = {message: "Table found"}
      res.each(:as => :hash) {|ppp| rows << ppp}
    end
    render :json => {status: status, data: data.merge!(rows: rows)}
  end
  
  def create
    
  end
  
  def update
    
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @connection = ActiveRecord::Base.connection
    end

end
