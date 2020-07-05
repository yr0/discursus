module ArticlesHelper
  # returns column weight for article, depending on its position in list on the first page
  def column_weight_from_index(index)
    if [0, 4].include?(index)
      5
    elsif [2, 3].include?(index)
      4
    else
      3
    end
  end

  # sets background image for article card if image is present, otherwise returns nothing
  def background_style_for_article(article)
    return if article.image.blank?

    "background-image: url(#{article.image.url(:large)})"
  end
end
