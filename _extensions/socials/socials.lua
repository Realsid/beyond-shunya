-- Reformat all heading text 
function Header(el)
  el.content = pandoc.Emph(el.content)
  return el
end

-- Add social share buttons when social-share: true is specified in metadata
function Pandoc(doc)
  -- Get the document metadata
  local meta = doc.meta
  
  -- Check if social-share is enabled in the metadata
  if meta["social-share"] and (meta["social-share"] == true or meta["social-share"].boolean) then
    -- Get the document title (if available)
    local title = ""
    if meta.title then
      -- Convert the title to plain text
      local title_blocks = pandoc.utils.stringify(meta.title)
      title = " - " .. title_blocks
    end
    
    -- Get the page URL
    local page_url = ""
    if meta["site-url"] then
      page_url = pandoc.utils.stringify(meta["site-url"])
    end
    
    -- Create the social sharing HTML block
    local social_html = [[
<style>
  /* CSS to override iframe dimensions and create consistent layout */
  .social-share-container {
    display: flex;
    flex-direction: column;
    margin: 20px 0;
  }
  .social-share-item {
    margin-bottom: 8px;
    min-height: 28px;
    display: flex;
    align-items: center;
  }
  .twitter-container iframe {
    margin: 0 !important;
    vertical-align: middle !important;
  }
  .hn-button {
    display: inline-flex;
    align-items: center;
    text-decoration: none;
    color: #ff6600;
    font-family: Verdana, Geneva, sans-serif;
    font-size: 14px;
    height: 28px;
    line-height: 28px;
  }
  .hn-button-icon {
    display: inline-block;
    background-color: #ff6600;
    color: white;
    padding: 1px 4px;
    margin-right: 5px;
  }
</style>

<div class="social-share-container">
  <!-- X/Twitter Post button -->
  <div class="social-share-item twitter-container">
    <a href="https://twitter.com/share" 
       class="twitter-share-button" 
       data-url="]] .. page_url .. [[" 
       data-text="Check out this post]] .. title .. [[">
      Tweet
    </a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
  </div>
  
  <!-- Hacker News share button -->
  <div class="social-share-item">
    <a href="https://news.ycombinator.com/submitlink?u=]] .. page_url .. [[&t=]] .. title .. [[" 
       target="_blank" 
       class="hn-button">
      <span class="hn-button-icon">Y</span>
      <span>Share on HN</span>
    </a>
  </div>
  
  <!-- LinkedIn share button -->
  <div class="social-share-item">
    <script src="https://platform.linkedin.com/in.js" type="text/javascript">lang: en_US</script>
    <script type="IN/Share" data-url="]] .. page_url .. [["></script>
  </div>
</div>
]]
    
    -- Add the social sharing HTML block to the end of the document
    local social_block = pandoc.RawBlock("html", social_html)
    doc.blocks:insert(social_block)
  end
  
  return doc
end
