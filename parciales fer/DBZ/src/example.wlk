// Guerreros y Saiyans

class Guerrero{
	var property potencialOfensivo
	var property nivelDeExperiencia = 0
	const nivelDeEnergiaBase
	var nivelDeEnergiaActual = nivelDeEnergiaBase
	
	var property traje
	
	// Metodos de energia
	
	method estaMuerto() = nivelDeEnergiaActual <= 0
	
	method disminuirEnergia(cantidad){
		nivelDeEnergiaActual -= cantidad
	}
	method recibirDanio(cantidad){
		traje.recibirDanio(self, cantidad)
	}
	method comerSemillaDelErmitaneo(){
		nivelDeEnergiaActual = nivelDeEnergiaBase
	}
	
	// Metodos de experiencia
	
	method aumentarExperiencia(cantidad){
		nivelDeExperiencia += cantidad
	}
	method ganarExperiencia(cantidad){
		traje.aumentarExperiencia(self, cantidad)
	} 
		
	// Luchar contra guerrero
	
	method atacarA(guerrero){
		guerrero.recibirDanio(potencialOfensivo.div(10))
		self.ganarExperiencia(1)
	}
}

class Saiyan inherits Guerrero{
	var property nivel = base
	
	// Metodos para cambios de caracteristicas
	
	method cambiarDeNivel(nuevoNivel){
		nivel = nuevoNivel
	}
	method aumentarPoderEnPorcentaje(porcentaje){
		potencialOfensivo += (potencialOfensivo * porcentaje/100)
	}
	
	// Metodos para personaje
	
	method convertirseEnSuperSaiyan(nivelDeSaiyan){
		self.cambiarDeNivel(nivelDeSaiyan)
		nivel.aumentarPoder(self, 50)
	}
	method volverAEstadoBase(){
		if(nivelDeEnergiaActual < nivelDeEnergiaBase){
			self.cambiarDeNivel(base)
		}
	}
	override method comerSemillaDelErmitaneo(){
		super()
		self.aumentarPoderEnPorcentaje(5)
	}
	override method recibirDanio(cantidad){
		super(cantidad - cantidad * nivel.resistencia() / 100)
	}
}

// Niveles de saiyan

class NivelSuperSaiyan{
	method aumentarPoder(saiyan, cantidad){
		saiyan.aumentarPoderEnPorcentaje(cantidad)
	}
	method resistencia()
}

object base inherits NivelSuperSaiyan{
	override method resistencia() = 0
	override method aumentarPoder(saiyan, cantidad){super(saiyan, 0)}
}

object nivelUno inherits NivelSuperSaiyan{
	override method resistencia() = 5
}

object nivelDos inherits NivelSuperSaiyan{
	override method resistencia() = 7
}

object nivelTres inherits NivelSuperSaiyan{
	override method resistencia() = 15
}

// Clases de trajes

object desprotegido{
	method cantidadDePiezas() = 1
	
	method recibirDanio(guerrero, cantidad){
		guerrero.disminuirEnergia(cantidad)
	}
	method aumentarExperiencia(guerrero, cantidad){
		guerrero.aumentarExperiencia(cantidad)
	}
}

class Traje{
	var property nivelDeDesgaste = 0
	
	method cantidadDePiezas() = 1
	
	method aumentarNivelDeDesgaste(cantidad){
		nivelDeDesgaste += cantidad
	}
	method estaGastado() = nivelDeDesgaste >= 100
	
	method recibirDanio(guerrero, cantidad){
		self.aumentarNivelDeDesgaste(5)
			if(self.estaGastado()){
				guerrero.traje(desprotegido)
			}
	}
	method aumentarExperiencia(guerrero, cantidad)
}

class TrajeComun inherits Traje{
	var property porcentajeDanioAbsorbido
	
	override method recibirDanio(guerrero, cantidad){
		guerrero.disminuirEnergia(cantidad - (cantidad * porcentajeDanioAbsorbido / 100))
		super(guerrero, cantidad)
	}
	override method aumentarExperiencia(guerrero, cantidad){
		guerrero.aumentarExperiencia(cantidad)
	}
}

class TrajeDeEntrenamiento inherits Traje{
	var property boostExperiencia = 2
	
	override method recibirDanio(guerrero, cantidad){
		guerrero.disminuirEnergia(cantidad)
		super(guerrero, cantidad)
	}
	override method aumentarExperiencia(guerrero, cantidad){
		guerrero.aumentarExperiencia(cantidad * boostExperiencia)
	}
}

class TrajeModularizado inherits Traje{
	const property piezas = []
	
	method resistenciaTotal() = piezas.sum({pieza => if(!pieza.estaGastada()) pieza.resistencia() else 0})
	
	method cantidadDePiezasGastadas() = piezas.filter({pieza => pieza.estaGastada()}).size()
	
	override method cantidadDePiezas() = piezas.size()
	
	override method recibirDanio(guerrero, cantidad){
		guerrero.disminuirEnergia((cantidad - self.resistenciaTotal()).max(0))
	}
	override method aumentarExperiencia(guerrero, cantidad){
		if(self.cantidadDePiezasGastadas() == 0){
			guerrero.aumentarExperiencia(1)
		}else if(self.cantidadDePiezasGastadas() == 2){
			guerrero.aumentarExperiencia(0.8)
		}else if(self.cantidadDePiezasGastadas() == 5){
			guerrero.aumentarExperiencia(0.5)
		}
	}
	override method estaGastado() = piezas.all({pieza => pieza.estaGastada()})
}

class PiezaDeTraje{
	var property resistencia
	var  property nivelDeDesgaste = 0
	
	method estaGastada() = nivelDeDesgaste >= 20
}

// TIPOS DE TORNEOS

class Torneo{
	const property interesados = []
	
	method seleccionarParticipantes()
}

object powerlsBelts inherits Torneo{
	override method seleccionarParticipantes() = interesados.sortedBy({interesado1, interesado2 => interesado1.potencialOfensivo() > interesado2.potencialOfensivo()}).take(16)
}

object funny inherits Torneo{
	override method seleccionarParticipantes() = interesados.sortedBy({interesado1, interesado2 => interesado1.traje().cantidadDePiezas() > interesado2.traje().cantidadDePiezas()}).take(16)
}

object surprise inherits Torneo{
	override method seleccionarParticipantes() = interesados.take(16)
}

