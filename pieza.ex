defmodule Pieza do

  defstruct codigo: 0, nombre: " ", valor: 0, unidad: " ", stock: 0

  def crear(codigo, nombre, valor, unidad, stock) do
    %Pieza{codigo: codigo, nombre: nombre, valor: valor, unidad: unidad, stock: stock}
  end

  #funcion que lee el archivo csv y devuelve la lista de piezas
  def leer_piezas(nombre_archivo) do
    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        String.split(contenido, "\n", trim: true)
        |> Enum.map(fn linea ->
          case String.split(linea, ",", trim: true) do
            [codigo, nombre, valor_str, unidad, stock_str] ->
              %Pieza{
                codigo: codigo,
                nombre: nombre,
                valor: String.to_integer(valor_str),
                unidad: unidad,
                stock: String.to_integer(stock_str)
              }

            _ ->
              nil
          end
        end)
        |> Enum.filter(& &1)

      {:error, reason} ->
        IO.puts("Error al leer el archivo: #{reason}")
        []
    end
  end

  #funcion que guarda el inventario
  def guardar_inventario(nombre_archivo, piezas) do
    headers= "Codigo, Nombre, Valor, Unidad, Stock\n"

    contenido =
      Enum.map(piezas, fn p ->
        "#{p.codigo},#{p.nombre},#{p.valor},#{p.unidad},#{p.stock}"
      end)
      |> Enum.join("\n")

    case File.write(nombre_archivo, headers <> contenido) do
      :ok -> IO.puts("Inventario guardado en #{nombre_archivo}")
      {:error, razon} -> IO.puts("Error al guardar: #{razon}")
    end
  end

  #funcion recursiva que cuenta cuantas piezas tienen stock < t, dado un umbral t
  def contar([], _t) do
    0
  end
  def contar([%Pieza{stock: stock} | tail], t) do
    if stock < t do
      1 + contar(tail, t)
    else
      contar(tail, t)
    end
  end

  #funcion recursiva que elimina elementos duplicados sin alterar el orden
  def eliminar_duplicados(piezas) do
    eliminar_duplicados(piezas, [])
  end
  def eliminar_duplicados([], acumulador) do
    invertir(acumulador, [])
  end
  def eliminar_duplicados([head | tail], acumulador) do
    if contiene?(head, acumulador) do
      eliminar_duplicados(tail, acumulador)
    else
      eliminar_duplicados(tail, [head | acumulador])
    end
  end

  #funcion auxiliar para ver si el elemento esta en la lista
  def contiene?(_, []) do
    false
  end
  def contiene?(elem, [head | tail]) do
    if head == elem do
      true
    else
      contiene?(elem, tail)
    end
  end

  #funcion auxiliar que invierte la lista para preservar el orden
  def invertir([], acumulador) do
    acumulador
  end
  def invertir([head | tail], acumulador) do
    invertir(tail, [head | acumulador])
  end

end
