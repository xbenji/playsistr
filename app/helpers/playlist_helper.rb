module PlaylistHelper

  def next_page_url text
     page = params[:page] || "0"
     html_url page.to_i + 1, text
  end

  def previous_page_url text
    page = params[:page] || "1"
    html_url [0, page.to_i - 1].max, text
  end

  def html_url offset, text

    tags_str = ""

    if params[:tags] and not params[:tags].empty?
      tags_str += "&tags="
      tags_str += params[:tags].split.join("+")
    end

    "<a href='?page=#{offset}#{tags_str}'>#{text}</a>".html_safe
  end

  def tag_url tag

    params[:tags] ||= ""
    class_str = ""
    tags_str = ""

    tags_a = params[:tags].split
    if tags_a.include? tag.name
      tags_a -= [tag.name]
      class_str = "class='tag_on'"
    else
      tags_a << tag.name
    end

    tags_str = "tags="
    tags_str += tags_a.join("+")

    html = "<a href='?#{tags_str}' #{class_str}>#{tag.name}</a>"
    html.html_safe

  end

end
