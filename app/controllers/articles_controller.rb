class ArticlesController < ApplicationController

  # http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

  def index
    @articles = Article.all
    @emails = ["hcler.greenhouse@gmail.com", "hardy.clervil@greenhouse.io"]
  end

  def lookup
    @domain = params[:domain]

    response = RestClient.get "https://api.mailgun.net/v3/#{@domain}/bounces?per_page=100", {:Authorization => "Basic #{ENV.fetch('MAILGUN_KEY')}"}
    response = JSON.parse(response)

    @csv_array = []

    while response["items"] != []
      response["items"].each do |h|
        @csv_array.push(h["address"])
      end
      
      url=response["paging"]["next"]
      response = RestClient.get url, {:Authorization => "Basic #{ENV.fetch('MAILGUN_KEY')}"}
      response = JSON.parse(response)
    end
  end
 
  def show
    @article = Article.find(params[:id])
  end
 
  def new
    @article = Article.new
  end
 
  def edit
    @article = Article.find(params[:id])
  end
 
  def create
    @article = Article.new(article_params)
 
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end
 
  def update
    @article = Article.find(params[:id])
 
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end
 
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
 
    redirect_to articles_path
  end
 
  private
  
    def article_params
      params.require(:article).permit(:title, :text)
    end
end