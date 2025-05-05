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
    flex-direction: row;
    gap: 10px;
    margin: 20px 0;
  }
  .social-share-item {
    display: flex;
    align-items: center;
  }
  .social-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    font-family: Arial, sans-serif;
    font-size: 14px;
    height: 36px;
    line-height: 36px;
    border-radius: 18px;
    padding: 0 16px;
    transition: opacity 0.2s;
    min-width: 110px;
  }
  .social-btn:hover {
    opacity: 0.9;
  }
  .social-btn-icon {
    font-weight: bold;
    margin-right: 8px;
    display: inline-block;
  }
  .social-btn-text {
    display: inline-block;
  }
  .twitter-btn {
    background-color: #000000;
    color: white;
  }
  .hn-btn {
    background-color: #ff6600;
    color: white;
  }
  .linkedin-btn {
    background-color: #0077b5;
    color: white;
  }
  
  /* Responsive styles */
  @media (max-width: 600px) {
    .social-btn {
      min-width: unset;
      width: 36px;
      padding: 0;
    }
    .social-btn-text {
      display: none;
    }
    .social-btn-icon {
      margin-right: 0;
    }
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
    twitterDiv.className = 'social-share-item';
    twitterDiv.innerHTML = `
      <a href="https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedTitle}"
         target="_blank" 
         class="social-btn twitter-btn">
        <span class="social-btn-icon">𝕏</span>
        <span class="social-btn-text">Post</span>
      </a>
    `;
    container.appendChild(twitterDiv);
    
    // Hacker News button
    const hnDiv = document.createElement('div');
    hnDiv.className = 'social-share-item';
    hnDiv.innerHTML = `
      <a href="https://news.ycombinator.com/submitlink?u=${encodedUrl}&t=${encodedTitle}" 
         target="_blank" 
         class="social-btn hn-btn">
        <span class="social-btn-icon">Y</span>
        <span class="social-btn-text">Submit to HN</span>
      </a>
    `;
    container.appendChild(hnDiv);
    
    // LinkedIn button
    const linkedinDiv = document.createElement('div');
    linkedinDiv.className = 'social-share-item';
    linkedinDiv.innerHTML = `
      <a href="http://www.linkedin.com/shareArticle?mini=true&url=${encodedUrl}&title=${encodedTitle}" 
         target="_blank" 
         class="social-btn linkedin-btn">
         <span class="social-btn-icon">in</span>
         <span class="social-btn-text">Share on LinkedIn</span>
      </a>
    `;
    container.appendChild(linkedinDiv);
  });
</script>
]]
    
    -- Add the social sharing HTML block to the end of the document
    local social_block = pandoc.RawBlock("html", social_html)
    doc.blocks:insert(social_block)
  end
  
  return doc
end
