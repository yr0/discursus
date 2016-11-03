module ArticlesHelper
  # returns column weight for article, depending on its position in list on the first page
  def column_weight_from_index(i)
    if [0, 4].include?(i)
      5
    elsif [2, 3].include?(i)
      4
    else
      3
    end
  end

  # sets background image for article card if image is present, otherwise returns nothing
  def background_style_for_article(article, weight)
    return unless article.image.present?
    "background-image: url(#{article.image.url(weight == 5 ? :large : :medium)})"
  end
end
