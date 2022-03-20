import queries from "./sql"

/**
 * See if a user with the given id exists.
 *
 * @param id
 */
async function uexiste(id: string): Promise<boolean> {
  const success = await queries.findUser(id)
  if (success != null) return true
  else return false
}

// Export default
export default {
  has: uexiste
} as const
