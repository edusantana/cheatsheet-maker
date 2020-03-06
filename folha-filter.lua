-- Filter images with this function if the target format is LaTeX.
if FORMAT:match 'latex' then
  function Image (elem)
    -- Surround all images with image-centering raw LaTeX.
    return {
      pandoc.RawInline('latex', '\\hfill\\break{\\centering'),
      elem,
      pandoc.RawInline('latex', '\\par}')
    }
  end

  function Inlines (inlines)
    if inline == nil then
      return inline
    elseif inline.c == '…' then
      return pandoc.RawInline('latex', '\\dotfill')
    else
      return inline
    end
  end

  function Str(elem)
    if elem.text == "…" then
      return pandoc.RawInline('latex', '\\dotfill')
    else
      return elem
    end
  end


  function Pandoc(doc)
      local hblocks = {}
      for i,el in pairs(doc.blocks) do
          if (el.t == "Div" and el.attributes.cols ~= nil) then
            local estrela = ''
            if (el.classes:includes 'page') then
              estrela = '*'
            end
             table.insert(hblocks,pandoc.RawBlock('latex',
             '\\begin{multicols'.. estrela .. '}{' .. el.attributes.cols .. '}'))
             table.insert(hblocks,el)
             table.insert(hblocks,pandoc.RawBlock('latex', '\\end{multicols'.. estrela ..'}'))
          else
            table.insert(hblocks, el)
          end
      end
      return pandoc.Pandoc(hblocks, doc.meta)
  end
end

function Meta(m)
  m.date = os.date("%B %e, %Y")
  return m
end
