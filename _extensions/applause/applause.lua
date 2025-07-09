-- Add applause button when applause: true is specified in metadata
function Pandoc(doc)
    -- Get the document metadata
    local meta = doc.meta
    -- print the metadata
    for k, v in pairs(meta) do
        print(k, pandoc.utils.stringify(v))
    end
    -- Check if applause is enabled in the metadata
    if meta["applause"] and (meta["applause"] == true or meta["applause"].boolean) then
        local applause_html = [[
<style>
  .applause-container {
    display: flex;
    justify-content: center;
    margin: 20px 0;
    padding: 10px;
  }
</style>
<link rel="stylesheet" href="https://unpkg.com/applause-button/dist/applause-button.css" />
<script src="https://unpkg.com/applause-button/dist/applause-button.js"></script>
<div class="applause-container" id="applause-container"></div>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var url = window.location.origin + window.location.pathname;
    var canonical = document.querySelector('link[rel=canonical]');
    if (canonical) url = canonical.href;

    var applauseBtn = document.createElement('applause-button');
    applauseBtn.setAttribute('style', 'width: 58px; height: 58px;');
    applauseBtn.setAttribute('color', 'var(--bs-dark)');
    applauseBtn.setAttribute('multiclap', 'true');
    applauseBtn.setAttribute('url', url);

    document.getElementById('applause-container').appendChild(applauseBtn);
  });
</script>
]]

        -- Add the applause button HTML block to the end of the document
        local applause_block = pandoc.RawBlock("html", applause_html)
        doc.blocks:insert(applause_block)
    end

    return doc
end
