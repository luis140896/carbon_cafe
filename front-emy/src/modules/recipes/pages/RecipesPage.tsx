import { useState, useEffect } from 'react'
import { Plus, Search, Loader2, Trash2, Edit2, X, Save } from 'lucide-react'
import toast from 'react-hot-toast'
import Button from '@/shared/components/ui/Button'
import Input from '@/shared/components/ui/Input'
import { recipeService } from '@/core/api/recipeService'
import { productService } from '@/core/api/productService'
import { Recipe, RecipeItem, Product } from '@/types'

type RecipeItemForm = Omit<RecipeItem, 'quantity' | 'wastePercent'> & {
  quantity: number | string
  wastePercent?: number | string
}

type RecipeForm = Omit<Recipe, 'yieldQty' | 'items'> & {
  yieldQty: number | string
  items: RecipeItemForm[]
}

const RecipesPage = () => {
  const [recipes, setRecipes] = useState<Recipe[]>([])
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [showModal, setShowModal] = useState(false)
  const [saving, setSaving] = useState(false)

  const [form, setForm] = useState<RecipeForm>({
    productId: 0,
    yieldQty: 1,
    items: []
  })

  useEffect(() => {
    fetchData()
    fetchProducts()
  }, [])

  const fetchData = async () => {
    try {
      const res: any = await recipeService.getAll()
      setRecipes(Array.isArray(res) ? res : res?.content || res?.data || [])
    } catch (error: any) {
      toast.error(error.response?.data?.message || 'Error al cargar recetas')
    } finally {
      setLoading(false)
    }
  }

  const fetchProducts = async () => {
    try {
      const res: any = await productService.getActive()
      setProducts(Array.isArray(res) ? res : res?.content || res?.data || [])
    } catch (error) {
      setProducts([])
    }
  }

  const openNew = () => {
    setForm({ productId: 0, yieldQty: 1, items: [] })
    setShowModal(true)
  }

  const openEdit = (r: Recipe) => {
    setForm({ ...r })
    setShowModal(true)
  }

  const addItem = () => {
    setForm(prev => ({
      ...prev,
      items: [...prev.items, { ingredientProductId: 0, quantity: '', wastePercent: '', sortOrder: prev.items.length }]
    }))
  }

  const updateItem = (index: number, key: keyof RecipeItemForm, value: any) => {
    setForm(prev => {
      const items = [...prev.items]
      items[index] = { ...items[index], [key]: value }
      return { ...prev, items }
    })
  }

  const removeItem = (index: number) => {
    setForm(prev => ({ ...prev, items: prev.items.filter((_, i) => i !== index) }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!form.productId) return toast.error('Seleccione el producto preparado')
    if (form.items.length === 0) return toast.error('Agregue al menos un ingrediente')

    if (!(Number(form.yieldQty) > 0)) return toast.error('Verifique el rendimiento')
    const invalid = form.items.some(i => !i.ingredientProductId || !(Number(i.quantity) > 0))
    if (invalid) return toast.error('Verifique ingredientes y cantidades')

    setSaving(true)
    try {
      await recipeService.save({
        productId: form.productId,
        yieldQty: Number(form.yieldQty),
        items: form.items.map(i => ({
          ingredientProductId: Number(i.ingredientProductId),
          quantity: Number(i.quantity),
          wastePercent: Number(i.wastePercent || 0),
          sortOrder: i.sortOrder
        }))
      })
      toast.success('Receta guardada')
      setShowModal(false)
      fetchData()
    } catch (error: any) {
      toast.error(error.response?.data?.message || 'Error al guardar receta')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = async (productId: number) => {
    if (!confirm('¿Inactivar la receta?')) return
    try {
      await recipeService.deleteByProductId(productId)
      toast.success('Receta inactivada')
      fetchData()
    } catch (error: any) {
      toast.error(error.response?.data?.message || 'Error al inactivar receta')
    }
  }

  const filtered = recipes.filter(r =>
    (r.productName || '').toLowerCase().includes(searchTerm.toLowerCase())
  )

  return (
    <div className="space-y-6 animate-fade-in p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">Recetas</h1>
          <p className="text-gray-500">Asocia ingredientes a productos preparados</p>
        </div>
        <Button variant="primary" onClick={openNew}>
          <Plus size={20} /> Nueva Receta
        </Button>
      </div>

      <div className="card">
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
          <input
            type="text"
            placeholder="Buscar receta..."
            className="input-field pl-12"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      <div className="card overflow-hidden p-0">
        {loading ? (
          <div className="flex items-center justify-center py-12">
            <Loader2 className="w-8 h-8 animate-spin text-primary-600" />
          </div>
        ) : filtered.length === 0 ? (
          <div className="py-12 text-center text-gray-400">No se encontraron recetas</div>
        ) : (
          <table className="w-full">
            <thead>
              <tr className="bg-primary-50">
                <th className="table-header">Producto</th>
                <th className="table-header">Rendimiento</th>
                <th className="table-header">Ingredientes</th>
                <th className="table-header text-center">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map(r => (
                <tr key={r.id} className="hover:bg-primary-50/50 transition-colors">
                  <td className="table-cell font-medium">{r.productName || r.productId}</td>
                  <td className="table-cell">{r.yieldQty}</td>
                  <td className="table-cell">{r.items?.length || 0}</td>
                  <td className="table-cell">
                    <div className="flex items-center justify-center gap-2">
                      <button onClick={() => openEdit(r)} className="p-2 rounded-lg hover:bg-primary-100 text-gray-500">
                        <Edit2 size={18} />
                      </button>
                      <button onClick={() => handleDelete(r.productId)} className="p-2 rounded-lg hover:bg-red-100 text-red-500">
                        <Trash2 size={18} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {showModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="modal-content-lg p-6 w-full max-w-3xl max-h-[90vh] overflow-y-auto animate-scale-in">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-xl font-bold text-gray-800">
                {form.id ? 'Editar Receta' : 'Nueva Receta'}
              </h3>
              <button onClick={() => setShowModal(false)} className="text-gray-400 hover:text-gray-600">
                <X size={24} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Producto preparado *</label>
                  <select
                    className="input-field"
                    value={form.productId}
                    onChange={(e) => setForm({ ...form, productId: Number(e.target.value) })}
                    disabled={!!form.id}
                    required
                  >
                    <option value={0}>Seleccione producto</option>
                    {products
                      .filter(p => {
                        const type = p.productType || 'DIRECTO'
                        return type === 'PREPARADO' || type === 'DIRECTO'
                      })
                      .map(p => (
                        <option key={p.id} value={p.id}>{p.name} ({p.unit || 'UNIDAD'})</option>
                      ))}
                  </select>
                </div>
                <Input
                  label="Rendimiento *"
                  type="number"
                  min="0.0001"
                  step="any"
                  value={form.yieldQty}
                  onChange={(e) => setForm({ ...form, yieldQty: e.target.value })}
                  required
                />
              </div>

              <div>
                <div className="flex items-center justify-between mb-2">
                  <h4 className="font-medium text-gray-700">Ingredientes</h4>
                  <Button type="button" variant="secondary" onClick={addItem}>
                    <Plus size={16} /> Agregar
                  </Button>
                </div>
                <div className="space-y-2">
                  {form.items.map((item, idx) => (
                    <div key={idx} className="grid grid-cols-12 gap-2 items-end border p-2 rounded-lg">
                      <div className="col-span-5">
                        <label className="text-xs text-gray-500">Ingrediente</label>
                        <select
                          className="input-field py-2"
                          value={item.ingredientProductId}
                          onChange={(e) => updateItem(idx, 'ingredientProductId', Number(e.target.value))}
                        >
                          <option value={0}>Seleccione</option>
                          {products
                            .filter(p => {
                              if (p.id === form.productId) return false
                              const type = p.productType || 'DIRECTO'
                              return type === 'INSUMO' || type === 'DIRECTO'
                            })
                            .map(p => (
                              <option key={p.id} value={p.id}>{p.name} ({p.unit || 'UNIDAD'})</option>
                            ))}
                        </select>
                      </div>
                      <div className="col-span-3">
                        <label className="text-xs text-gray-500">Cantidad</label>
                        <input
                          type="number"
                          min="0.0001"
                          step="any"
                          className="input-field py-2"
                          value={item.quantity ?? ''}
                          onChange={(e) => updateItem(idx, 'quantity', e.target.value)}
                        />
                      </div>
                      <div className="col-span-3">
                        <label className="text-xs text-gray-500">% Merma</label>
                        <input
                          type="number"
                          min="0"
                          step="any"
                          className="input-field py-2"
                          value={item.wastePercent ?? ''}
                          onChange={(e) => updateItem(idx, 'wastePercent', e.target.value)}
                        />
                      </div>
                      <div className="col-span-1">
                        <button type="button" onClick={() => removeItem(idx)} className="p-2 rounded hover:bg-red-100 text-red-500">
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div className="flex justify-end gap-3 pt-4">
                <Button type="button" variant="secondary" onClick={() => setShowModal(false)}>
                  Cancelar
                </Button>
                <Button type="submit" variant="primary" disabled={saving}>
                  {saving ? <><Loader2 className="w-5 h-5 animate-spin" /> Guardando...</> : <><Save size={18} /> Guardar</>}
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}

export default RecipesPage
