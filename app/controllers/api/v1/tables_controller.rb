class Api::V1::TablesController < ApplicationController
  before_action :set_table, only: [:show, :edit, :update, :destroy]

  # GET /tables
  # GET /tables.json
  def index
    #curl --basic --header "Content-Type:application/jsonalhost:3000/api/v1/tables -H 'Authorization: Token id="id", secret="sec"' -X GET
  end

  # GET /tables/1
  # GET /tables/1.json
  def table_using_name
    # sample localhost:3000/api/v1/tables/create_table?table_name=nameoftable with get
    begin
      if params[:table_name] && (!check_table_exists)
        render :json => {status: "true", columns: "Table does not Exists."} and return
      end
      col = []
      columns = ActiveRecord::Base.connection.columns(params[:table_name])
      columns.each do |cl| 
       col << [cl.name,cl.type]
      end
      msg = col
    rescue
      msg = "Something went Wrong."
    end
    render :json => {status: "true", columns: msg}
  end
  
  def update_table
    # sample localhost:3000/api/v1/tables/update_table?table_name=nameoftable and the params in hash with keys as column and value as type with put
    begin
      if params[:table_name] && (!check_table_exists)
        render :json => {status: "true", columns: "Table does not Exists."} and return
      end
      sql = "DROP TABLE #{params[:table_name]}"
      ActiveRecord::Base.establish_connection.connection.execute(sql);
      create_table_method
      msg = "Table updated successfully"
    rescue
      msg = "Something went wrong"
    end
    render :json => {status: "true", message: msg}
  end
  
  def create_table
    # sample localhost:3000/api/v1/tables/update_table?table_name=nameoftable and the params in hash with keys as column and value as type with post
    begin
      if params[:table_name] && (check_table_exists)
        render :json => {status: "true", columns: "Table already exists."} and return
      end
      create_table_method
      msg="Table Created"
    rescue
      msg="Something went wrong."
    end
    render :json => {status: "true", message: msg}
  end
  
  def delete_table
    # sample localhost:3000/api/v1/tables/update_table?table_name=nameoftable  with delete
    begin
      if params[:table_name] && (!check_table_exists)
        render :json => {status: "true", columns: "Table does not exists"} and return
      end
      sql = "DROP TABLE #{params[:table_name]}"
      ActiveRecord::Base.establish_connection.connection.execute(sql);
      msg="Table Deleted Sucessfully"
    rescue
      msg="Table doest not Exists."
    end
    render :json => {status: "true", message: msg}
  end
  
  
  
  def show

  end

  # GET /tables/new
  def new
    @table = Table.new
  end

  # GET /tables/1/edit
  def edit
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(table_params)

    respond_to do |format|
      if @table.save
        format.html { redirect_to @table, notice: 'Table was successfully created.' }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to @table, notice: 'Table was successfully updated.' }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table.destroy
    respond_to do |format|
      format.html { redirect_to tables_url, notice: 'Table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @table = Table.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def table_params
      params[:table]
    end
    
    def create_table_method
      make_string = ""
      params[:table_name] = "lists" unless params[:table_name] #remove this line when using parameters
      a = {"field1" => "text","field2" => "text"} #remove this line when using parameters
      a.each_with_index do |name,index|
        if ((a.length-1) == (index))
          make_string = make_string+"#{name[0]} #{name[1]}"
        else
          make_string = make_string+"#{name[0]} #{name[1]},"
        end
      end
      sql = "CREATE TABLE IF NOT EXISTS "+params[:table_name]+" (#{make_string})"
      @result = ActiveRecord::Base.establish_connection.connection.execute(sql);
    end
    
    def check_table_exists
      if params[:table_name]
        return ActiveRecord::Base.connection.tables.include?params[:table_name]
      else
        return nil
      end
    end
end
