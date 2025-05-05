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
    
    -- Get the page URL using JavaScript instead of metadata
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

<div class="social-share-container" id="social-share-container">
  <!-- Social share buttons will be inserted here by JavaScript -->
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Get current page URL
    const pageUrl = window.location.href;
    const encodedUrl = encodeURIComponent(pageUrl);
    const pageTitle = document.title;
    const encodedTitle = encodeURIComponent(pageTitle);
    
    // Create container for social buttons
    const container = document.getElementById('social-share-container');
    
    // Twitter button
    const twitterDiv = document.createElement('div');
    twitterDiv.className = 'social-share-item twitter-container';
    twitterDiv.innerHTML = `
      <a href="https://twitter.com/share" 
         class="twitter-share-button" 
         data-url="${pageUrl}" 
         data-text="Check out this post - ${pageTitle}">
        Tweet
      </a>
    `;
    container.appendChild(twitterDiv);
    
    // Load Twitter widget
    const twitterScript = document.createElement('script');
    twitterScript.innerHTML = `
      !function(d,s,id){
        var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
        if(!d.getElementById(id)){
          js=d.createElement(s);js.id=id;
          js.src=p+'://platform.twitter.com/widgets.js';
          fjs.parentNode.insertBefore(js,fjs);
        }
      }(document, 'script', 'twitter-wjs');
    `;
    document.body.appendChild(twitterScript);
    
    // Hacker News button
    const hnDiv = document.createElement('div');
    hnDiv.className = 'social-share-item';
    hnDiv.innerHTML = `
      <a href="https://news.ycombinator.com/submitlink?u=${encodedUrl}&t=${encodedTitle}" 
         target="_blank" 
         class="hn-button">
        <span class="hn-button-icon">Y</span>
        <span>Share on HN</span>
      </a>
    `;
    container.appendChild(hnDiv);
    
    // LinkedIn button
    const linkedinDiv = document.createElement('div');
    linkedinDiv.className = 'social-share-item';
    linkedinDiv.innerHTML = `
      <div class="linkedin-share-button"></div>
    `;
    container.appendChild(linkedinDiv);
    
    // Load LinkedIn widget
    const linkedinScript = document.createElement('script');
    linkedinScript.src = 'https://platform.linkedin.com/in.js';
    linkedinScript.type = 'text/javascript';
    linkedinScript.innerHTML = 'lang: en_US';
    document.body.appendChild(linkedinScript);
    
    // Create LinkedIn share button after script loads
    linkedinScript.onload = function() {
      if (typeof IN !== 'undefined') {
        IN.init();
        const linkedinButtonContainer = document.querySelector('.linkedin-share-button');
        const button = document.createElement('script');
        button.type = 'IN/Share';
        button.setAttribute('data-url', pageUrl);
        linkedinButtonContainer.appendChild(button);
        if (typeof IN.parse === 'function') {
          IN.parse();
        }
      }
    };
  });
</script>
]]
    
    -- Add the social sharing HTML block to the end of the document
    local social_block = pandoc.RawBlock("html", social_html)
    doc.blocks:insert(social_block)
  end
  
  return doc
end
