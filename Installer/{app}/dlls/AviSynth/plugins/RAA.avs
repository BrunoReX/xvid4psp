# Residual Anti-Aliasing
function RAA (clip input) {
w=input.width()
h=input.height()

input.spline64resize(w*2,h*2).eedi3(vcheck=3).spline64resize(w,h)
}