class Personaje {
  const fuerza
  const inteligencia
  var rol
  
  method rol() = rol
  
  method fuerza() = fuerza
  
  method inteligencia() = inteligencia
  
  method cambiarRol(unRol) {
    rol = unRol
  }
  
  method potencialOfensivo() = (fuerza * 10) + rol.potencialOfensivo()
  
  method esGroso() = self.esInteligente() || rol.esGroso(self)
  
  method esInteligente()
}

class Humano inherits Personaje {
  override method esInteligente() = inteligencia > 50
}

class Orco inherits Personaje {
  override method potencialOfensivo() = super() * 1.1
  
  override method esInteligente() = false
}

class Rol {
  method potencialOfensivo()
  
  method esGroso(personaje)
}

object guerrero inherits Rol {
  override method potencialOfensivo() = 100
  
  override method esGroso(personaje) = personaje.fuerza() > 50
}

class Cazador inherits Rol {
  const property mascota
  
  override method potencialOfensivo() = mascota.potencialOfensivo()
  
  override method esGroso(personaje) = mascota.esLongeva()
}

object brujo inherits Rol {
  override method potencialOfensivo() = 0
  
  override method esGroso(personaje) = true
}

class Mascota {
  const property fuerza
  var edad
  const property garras
  
  method edad() = edad
  
  method potencialOfensivo() = if (garras) fuerza * 2 else fuerza
  
  method aumentarEdad() {
    edad += 1
  }
  
  method esLongeva() = edad > 10
}

class Ejercito {
  const personajes = []
  
  method personajes() = personajes
  
  method agregarPersonaje(unPersonaje) {
    personajes.add(unPersonaje)
  }
  
  method potencialOfensivo() = personajes.sum({ p => p.potencialOfensivo() })
  
  method ocupar(unaLocalidad) {
    if (unaLocalidad.entran(personajes.size()))
      unaLocalidad.agregarListaHabitantes(personajes)
    else unaLocalidad.agregarListaHabitantes(
        self.nuevoEjercitoFuerte(10).personajes()
      )
  }
  
  method nuevoEjercitoFuerte(unaCantidad) {
    const nuevoEjercito = personajes.sortBy(
      { p1, p2 => p1.potencialOfensivo() > p2.potencialOfensivo() }
    ).take(unaCantidad)
    personajes.removeAll(nuevoEjercito)
    return new Ejercito(personajes = nuevoEjercito)
  }
}

class Localidad {
  const property habitantes = []
  
  method agregarListaHabitantes(unaLista)
  
  method potencialOfensivo() = habitantes.sum({ h => h.potencialOfensivo() })
  
  method recibirInvasion(unEjercito) {
    if (unEjercito.potencialOfensivo() > self.potencialOfensivo()) {
      habitantes.clear()
      unEjercito.ocupar(self)
    }
  }
}

class Aldea inherits Localidad {
  const maxHabitantes
  
  method entran(
    cantidadDePersonas
  ) = (habitantes.size() + cantidadDePersonas) < maxHabitantes
  
  override method agregarListaHabitantes(unaLista) {
    if (self.entran(unaLista.size())) habitantes.addAll(unaLista)
  }
}

class Ciudad inherits Localidad {
  method entran(cantidadDePersonas) = true
  
  override method potencialOfensivo() = super() + 300
  
  override method agregarListaHabitantes(unaLista) {
    habitantes.addAll(unaLista)
  }
}