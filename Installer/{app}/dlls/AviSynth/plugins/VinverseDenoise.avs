function VinverseDenoise(clip c, int "sigma") {
  sigma = default(sigma, 2)

  nr=c.FFT3DFilter(sigma=sigma)
  vi=nr.VinverseD(sstr=2.6,amnt=15, uv=3)
  nrd=mt_makediff(c, nr)
  vi.mt_adddiff(nrd, U=2, V=2)
}