require "paginator"

function get()
    local page = 0

    if http.getValues.page ~= nil then
        page = math.floor(tonumber(http.getValues.page) + 0.5)
    end

    if page < 0 then
        http:redirect("/subtopic/index")
        return
    end

    local articleCount = db:singleQuery("SELECT COUNT(*) as total FROM castro_articles", true)
    local pg = paginator(page, 5, tonumber(articleCount.total))
    local data = {}

    data.articles, cached = db:query("SELECT title, text, created_at FROM castro_articles ORDER BY id DESC LIMIT ?, ?", pg.offset, pg.limit, true)
    data.paginator = pg

    if data.articles == nil and page > 0 then
        http:redirect("/subtopic/index")
        return
    end

    if data.articles ~= nil then
        if not cached then
            for _, article in pairs(data.articles) do
                article.created = time:parseUnix(article.created_at)
            end
        end
    end

    http:render("home.html", data)
end
