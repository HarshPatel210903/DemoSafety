using DemoSafety.Models;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.FileSystemGlobbing;

using System.Data;

namespace DemoSafety.Pages
{
    public class LoginModel : PageModel
    {
        public List<SelectListItem> Organizations { get; set; }

        private readonly string connectionString;
        public LoginModel(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }
        public async Task OnGet()
        {
            await PopulateDropdownsAsync();
        }

        private async Task PopulateDropdownsAsync()
        {
            Organizations = await GetDropdownItemsAsync("SELECT Id, Type FROM tRoleType");
        }
        private async Task<List<SelectListItem>> GetDropdownItemsAsync(string query)
        {
            var dropdownItems = new List<SelectListItem>();

            try
            {
                DataTable result = await adoMethod.ExecuteAsyncTodata(connectionString, query);

                foreach (DataRow row in result.Rows)
                {
                    dropdownItems.Add(new SelectListItem
                    {
                        Value = row[0].ToString(),
                        Text = row[1].ToString()
                    });
                }
            }
            catch (Exception ex)
            {
                // Handle exception
                Console.WriteLine(ex.Message);
            }

            return dropdownItems;
        }
    }
}
