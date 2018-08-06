class HellosController < ApplicationController
  before_action :set_hello, only: [:show, :edit, :update, :destroy]

  # GET /hellos
  def index
    @hellos = Hello.all
  end

  # GET /hellos/1
  def show
  end

  # GET /hellos/new
  def new
    @hello = Hello.new
  end

  # GET /hellos/1/edit
  def edit
  end

  # POST /hellos
  def create
    @hello = Hello.new(hello_params)

    if @hello.save
      redirect_to @hello, notice: 'Hello was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /hellos/1
  def update
    if @hello.update(hello_params)
      redirect_to @hello, notice: 'Hello was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hellos/1
  def destroy
    @hello.destroy
    redirect_to hellos_url, notice: 'Hello was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hello
      @hello = Hello.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hello_params
      params.require(:hello).permit(:name)
    end
end
