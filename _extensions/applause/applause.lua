-- Add applause button when applause: true is specified in metadata
function Pandoc(doc)
    -- Get the document metadata
    local meta = doc.meta

    -- Check if applause is enabled in the metadata
    if meta["applause"] and (meta["applause"] == true or meta["applause"].boolean) then
        -- Create the applause button HTML block with dark theme
        local applause_html = [[
<style>
  /* Applause button container styling */
  .applause-container {
    display: flex;
    justify-content: center;
    margin: 20px 0;
    padding: 10px;
  }
</style>

<!-- Applause Button CSS and JS from CDN -->
<link rel="stylesheet" href="https://unpkg.com/applause-button/dist/applause-button.css" />
<script src="https://unpkg.com/applause-button/dist/applause-button.js"></script>

<div class="applause-container">
  <applause-button id="applause-btn" style="width: 58px; height: 58px;" color="var(--bs-dark)" multiclap="true"></applause-button>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var applauseBtn = document.getElementById('applause-btn');
      if (applauseBtn) {
        // Use canonical URL if available, otherwise fallback to origin+pathname
        var canonical = document.querySelector('link[rel=canonical]');
        var url = canonical ? canonical.href : window.location.origin + window.location.pathname;
        applauseBtn.setAttribute('url', url);
      }
    });
  </script>
</div>
]]

        -- Add the applause button HTML block to the end of the document
        local applause_block = pandoc.RawBlock("html", applause_html)
        doc.blocks:insert(applause_block)
    end

    return doc
end
