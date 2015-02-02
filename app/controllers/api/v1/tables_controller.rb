class Api::V1::TablesController < ApplicationController
  before_action :set_table, only: [:show, :edit, :update, :destroy]

  # GET /tables
  # GET /tables.json
  def index
    #curl --basic --header "Content-Type:application/jsonalhost:3000/api/v1/tables -H 'Authorization: Token id="id", secret="sec"' -X GET
    
    @connection = ActiveRecord::Base.establish_connection(
      :adapter => "mysql2",
      :host => "localhost",
      :database => "jeff_development",
      :username => "root",
      :password => "root"
    )
    make_string = ""
    params[:table_name] = "lists"
    a = {"field1" => "text","field2" => "text"}
    a.each_with_index do |name,index|
      if ((a.length-1) == (index))
        make_string = make_string+"#{name[0]} #{name[1]}"
      else
        make_string = make_string+"#{name[0]} #{name[1]},"
      end
    end
    sql = "CREATE TABLE IF NOT EXISTS "+params[:table_name]+" (#{make_string})"
    @result = @connection.connection.execute(sql);

    render :json => {status: "true", message: "Table created"}
  end

  # GET /tables/1
  # GET /tables/1.json
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
end
