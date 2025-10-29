defmodule Movimiento do

  defstruct codigo: " ", tipo: " ", cantidad: 0, fecha: " "

  def crear(codigo, tipo, cantidad, fecha) do
    %Movimiento{codigo: codigo, tipo: tipo, cantidad: cantidad, fecha: fecha}
  end

  def leer_movimientos(nombre_archivo) do
    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        contenido
        |> String.split("\n", trim: true)
        |> Enum.map(fn linea ->
          case String.split(linea, ",", trim: true) do
            [codigo, tipo, cantidad_str, fecha] ->
              %Movimiento{
                codigo: codigo,
                tipo: tipo,
                cantidad: String.to_integer(cantidad_str),
                fecha: fecha
              }

            _ -> nil
          end
        end)
        |> Enum.filter(& &1)

      {:error, reason} ->
        IO.puts("Error al leer el archivo: #{reason}")
        []
    end
  end

  #funcion que guarda 
  def guardar(nombre_archivo, movimientos) do
    contenido =
      Enum.map(movimientos, fn m ->
        "#{m.codigo},#{m.tipo},#{m.cantidad},#{m.fecha}"
      end)
      |> Enum.join("\n")

    case File.write(nombre_archivo, contenido) do
      :ok -> IO.puts("Movimientos guardados en #{nombre_archivo}")
      {:error, reason} -> IO.puts("Error al guardar movimientos: #{reason}")
    end
  end


  # Función recursiva que suma las cantidades movidas entre dos fechas
  def total_movido_en_rango([], _fini, _ffin), do: 0

  def total_movido_en_rango([%Movimiento{fecha: fecha, cantidad: cantidad} | tail], fini, ffin) do
    if fecha >= fini and fecha <= ffin do
      cantidad + total_movido_en_rango(tail, fini, ffin)
    else
      total_movido_en_rango(tail, fini, ffin)
    end
  end


end
