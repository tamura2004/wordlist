class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  def maintenance
    Word.delete_all(removed: true)
    Word.find_each do |word|
      if word.name =~ /^\d+$/
        word.delete
      end
    end
    redirect_to :words
  end

  def count
    @count = Word.count
  end

  def upload
    user = cookies.signed[:name]
    file = params[:file].path.to_s
    xlsx = Roo::Excelx.new(file)

    xlsx.each_row_streaming do |row|
      name,desc = row.map(&:value)
      Word.create(name:name, desc:desc, user:user, removed:false)
    end
    redirect_to :words
  end

  # GET /words
  # GET /words.json
  # GET /words.xlsx
  def index
    respond_to do |format|
      format.json do
        @words = Word.where(removed: false).order("created_at desc")
      end

      format.xlsx do
        timestamp = Time.zone.now.strftime("%Y%m%d%H%M%S")
        filename = "wordlist_#{timestamp}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
      end

      format.html{}
    end
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json do
          @word.errors.full_messages do |message|
            logger.warn message
          end
          render json: @word.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json do
          @word.errors.full_messages do |message|
            logger.warn message
          end
          render json: @word.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:name, :desc, :user, :removed)
    end


end