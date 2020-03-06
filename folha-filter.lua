-- Filter images with this function if the target format is LaTeX.
if FORMAT:match 'latex' then

  function Str(elem)
    if elem.text == "…" then
      return pandoc.RawInline('latex', '\\dotfill')
    else
      return elem
    end
  end

  function adiciona_colunas(inicio,fim,el)
    if el.attributes.cols ~= nil then
      local estrela = ''
      if (el.classes:includes 'page') then
        estrela = '*'
      end
      table.insert(inicio,pandoc.RawBlock('latex',
      '\\begin{multicols'.. estrela .. '}{' .. el.attributes.cols .. '}'))

      print ('Adicionei c inicio: ' .. el.attributes.cols .. " // " .. el.classes[1])
      table.insert(fim,pandoc.RawBlock('latex', '\\end{multicols'.. estrela ..'}'))
      print ('Adicionei c fim: ' .. el.attributes.cols .. " // " .. el.classes[1])
    end
  end

  function adiciona_frame(inicio,fim,el)

    for _,classe in pairs(el.classes) do
      if classe == 'frame' then

        local atributos = ''
        for k,v in pairs(el.attributes) do
          -- ignora atributo de colunas
          if k ~= 'cols' then
            atributos = atributos .. k .. '=' .. v .. ','
          end
        end
        -- remove last ,
        if atributos ~= '' then
          atributos = atributos:sub(1, -2)
        end


        --\begin{mdframed}[backgroundcolor=gray!20]
        table.insert(inicio,pandoc.RawBlock('latex','\\begin{mdframed}[' .. atributos .. ']'))
        table.insert(fim, pandoc.RawBlock('latex', '\\end{mdframed}'))

        print ('Adicionei f inicio: ' .. el.attributes.cols .. " // " .. el.classes[1])
        print ('Adicionei f fim: ' .. el.attributes.cols .. " // " .. el.classes[1])
      end
    end


  end


  function Blocks (blocks)
    local hblocks = {}

    for n,el in pairs(blocks) do

      if el.t == 'Div' then
        print ("Encontrei bloco" .. el.t .. ' >> ' .. n)
        print ("classe: " .. el.classes[1])

        local inicio = {}
        local fim = {}

        adiciona_colunas(inicio,fim,el)
        --adiciona_frame(inicio,fim,el)

        -- Adciciona abertura \begin
        for _, elemento in pairs(inicio) do
          table.insert(hblocks,elemento)
        end

        table.insert(hblocks,el)
        -- Adciciona fechamento \end na ordem inversa
        for _, elemento in ipairs(fim) do
          table.insert(hblocks,elemento)
        end

      else
        table.insert(hblocks,el)
      end

    end

    return hblocks
  end

end

function Meta(m)
  m.date = os.date("%B %e, %Y")
  return m
end
