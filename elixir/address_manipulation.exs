defmodule AddressModification do

  def cycle([], _modifier), do: nil

  def cycle([%{charset: <<>>}|_rest], _modifier), do: nil

  def cycle([%{index: index, charset: charset}|rest], modifier) do
    <<head_char::utf8, rest_char::binary>> = charset
    
    ### This will be the address modification, checksum calculation, re-encoding, and validating
    mod = 
      if modifier[index] do
        %{modifier | index => head_char}
      else
        Map.put(modifier, index, head_char)
      end
    ###

    # just for debugging
    printable = :maps.filter fn _, v -> v != 122 end, mod
    if printable == %{} do
      IO.inspect mod
    end

    cycle(rest, mod)    
    cycle([%{index: index, charset: rest_char}] ++ rest, mod)
  end

end

b58chars = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
modifier = [%{:index => 8, :charset => b58chars},
            %{:index => 10, :charset => b58chars},
            %{:index => 14, :charset => b58chars},
            %{:index => 16, :charset => b58chars}]            

AddressModification.cycle(modifier, %{})

