

# ResourceStruct

![Integración Continua](https://github.com/AlexRiedler/resource-struct/actions/workflows/default.yml/badge.svg)

Esta es una gema para trabajar con recursos JSON provenientes de una fuente de red, con acceso indiferente y basado en métodos.

En lugar de sobrescribir la implementación de Hash, esta envuelve un Hash con acceso indiferente (por claves de símbolo o cadena).
Esto lo hace rápido en tiempo de ejecución, a la vez que proporciona el método de búsqueda que prefieras.

Existen dos tipos: `ResourceStruct::StrictStruct` y `ResourceStruct::FlexStruct`.

`ResourceStruct::StrictStruct` proporciona una forma de envolver un Hash de tal manera que los accesos a claves inválidas generarán una excepción a través de la búsqueda por métodos; además, es inmutable.

`ResourceStruct::FlexStruct` proporciona una forma de envolver un Hash de tal manera que devuelve nil en lugar de generar una excepción cuando la clave no está presente en el hash.

## Instalación

Agrega esta línea al Gemfile de tu aplicación:

```ruby
gem 'resource-struct'
```

Y luego ejecuta:

    $ bundle install

O instálala manualmente con:

    $ gem install resource-struct

## Uso

### StrictStruct

```ruby
struct = ResourceStruct::StrictStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })
struct.foo? # => true
struct.brr? # => false
struct.foo # => 1
struct.bar # => [StrictStruct<{ "baz" => 2 }>, 3]
struct.brr # => NoMethodError
struct[:foo] # => 1
struct[:brr] # => nil
struct[:bar, 0, :baz] # => 2
struct[:bar, 0, :brr] # => nil
```

### FlexStruct

```ruby
struct = ResourceStruct::FlexStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })

struct.foo? # => true
struct.brr? # => false
struct.foo # => 1
struct.bar # => [FlexStruct<{ "baz" => 2 }>, 3]
struct.brr # => nil
struct[:foo] # => 1
struct[:brr] # => nil
struct[:bar, 0, :baz] # => 2
struct[:bar, 0, :brr] # => nil
```


## Desarrollo

Después de clonar el repositorio, ejecuta `bin/setup` para instalar las dependencias. Luego, ejecuta `rake spec` para correr las pruebas. También puedes ejecutar `bin/console` para obtener una consola interactiva que te permitirá experimentar.

Para instalar esta gema en tu máquina local, ejecuta `bundle exec rake install`. Para lanzar una nueva versión, actualiza el número de versión en `version.rb` y luego ejecuta `bundle exec rake release`, lo cual creará una etiqueta git para la versión, enviará los commits y la etiqueta creada a git, y publicará el archivo `.gem` en [rubygems.org](https://rubygems.org).

## Contribución

Los informes de errores y las pull requests son bienvenidos en GitHub en https://github.com/AlexRiedler/resource-struct.

## Licencia

La gema está disponible como software de código abierto bajo los términos de la [Licencia MIT](https://opensource.org/licenses/MIT).
