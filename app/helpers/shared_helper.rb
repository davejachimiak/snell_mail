module SharedHelper
  def index_url?(url, error)
    url =~ /(s$|s\?)/ && !error
  end

  def new_url?(url, error)
    url =~ /new/ || error
  end
end
