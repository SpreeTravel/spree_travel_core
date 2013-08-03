Done
========
* add type to spree product
* el metodo parent
* el metodo children
* el metodo parent-relation-name
* el metodo children-relation-name


Pending
========

* arregla las cosas de acts as solr

* modifica los metodos de solr que ejecutan la busqueda
  - buscar en mas de un taxon a la vez (in-taxons-at-same-time)
  - devuelte sugerencias (revisar esto que creo que ya exsite pero no lo usamos)

* crea Spree::Product.solr-filter-queries
  - es un metodo que devuelte todos los filter queries que se van a aplicar
  - saca sus valores de una variable @@solr-filter-queries
  - la idea es que cada modulo/gema llene esa variable

* crea Spree::Product.solr-facets
  - similar a los filter queries cada modulo llena los facets que utiliza
  - define un hash con pares param-value => property-value
  - la idea es ver que parametro que viene en PARAMS va a parar a que @property en SOLR
  - la idea es saber que parametros son para facets, cuales para queries, etc.

* solr-search viene ya con un metodo para buscar por option-types
  - este adiciona uno para buscar por properties
  - otro para buscar por property-types
  - todo esto es para la busqueda facetada

* incorpora el concepto Spree::Context
  - que es para serializar las cosas de params en el momento de una compra
  - la idea es modificar LineItem u Order no se bien cual de los dos

* cada vez que un producto va al carrito se persiste en la base de datos el context

* cada vez que se vaya a calcular el precio se utiliza ese contexto

* unas promociones tocadas con imagencitas y cosas (pensar hacer una gemita con esto)

* sustituir el concepto de inventario por disponibilidad

* elimina de spree todo lo que tiene que ver con shipping de admin, de la vista, del checkout
  de ser posible de la base de datos tambien

* redefine el proceso de checkout para sacar las informacion del tipo de producto a comprar
  - obtiene los diferentes pasos/estados (eso se lo devuelve el producto)
  - para cada paso define la vista/formulario para el proceso de checkout
  - algo como views/checkout/#{order.product.type}/#{order.state}/
  - la clase order le pregunta al producto como debe calcularse, y como debe mostrarse y todo eso

* adiciona un div/partial/datahook para un buscador
  - ese buscador pregunta todos los herederos de spree-product (o algun otro mecanismo)
  - pone unos radio button para cada tipo
  - renderea un partial views/searcher/#{tipo} que contiene lo que define para buscar ese tipo

* define el modelo Spree::Constant
  - la idea es que cada modelo extienda esa clase y ponga sus contantes ahi
  - pensar si esto se resuelve con Spree::Config

* en las vistas de detalles de un producto se llama a un metodo [children] que por defecto no tiene nada
  - este metodo es para mostrar los "hijos" de un producto
  - cada modelo define quienes son sus hijos y redefine el metodo children

* se adiciona un metodo get-price para calcular el precio
  - por defecto get-price == price
  - cada modelo define como se calcula su precio
  - si devuelve nil es que ese producto no se compra
  - el get-price recibe como parametro un context


* se implementa un metodo para devolver las imagenes que cada heredero sobreescribe

* adiciona un atributo TYPE en product para saber el tipo
  - eso es obligatorio para poder hacer herencia simple en rails
  - ya con eso se resuelve lo del tipo

* implementa un metodo main-child que por defecto devuelve el primero de los children
  - cada heredero lo sobreescribe preferiblemente con relaciones

* implementa el metodo variant-for-context(context) que los herederos redefinen

* cada clase heredera de product define en Spree::Variant los metodos que le hacen falta

* implementa una clase Spree::Importer [no me queda bien claro todavia]
  - cada modulo define como se importan sus datos en .yml, .rb, .xls, db, openerp, etc.

* en la vista de listado de productos se llama en el ciclo a view/spree/products/#{producto-iesimo.tipo}-list.html.erb
  - esto es para la vista de listado

* en el caso de la vista de detalles se hace algo similar

* ver lo de imprimir las ordenes

* ver lo de los correos automaticos
