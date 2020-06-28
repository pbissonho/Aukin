using System;
using Microsoft.AspNetCore.Identity;
using APIProdutos.Data;
using APIProdutos.Models;
using System.Collections.Generic;

namespace APIProdutos.Security
{
    public class IdentityInitializer
    {
        private readonly ApplicationDbContext _context;
        private readonly AccessManager _accessManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public IdentityInitializer(
            ApplicationDbContext context,
            AccessManager accessManager,
            RoleManager<IdentityRole> roleManager)
        {
            _context = context;
            _accessManager = accessManager;
            _roleManager = roleManager;
        }

        public void Initialize()
        {
            if (_context.Database.EnsureCreated())
            {

                var result = _roleManager.CreateAsync(
                        new IdentityRole(Roles.ROLE_ADMIN)).Result;
                var result2 = _roleManager.CreateAsync(
                        new IdentityRole(Roles.ROLE_API_PRODUTOS)).Result;
                var result3 = _roleManager.CreateAsync(
                        new IdentityRole(Roles.ROLE_BASIC)).Result;

                //método para registrar todas as roles do sistema
                List<string> roles = new List<string>();

                //Listagem de todas as roles da API!
                roles.Add(Roles.ROLE_ADMIN);
                roles.Add(Roles.ROLE_BASIC);
                roles.Add(Roles.ROLE_API_PRODUTOS);


                _accessManager.CreateUser(
                    new ApplicationUser()
                    {
                        UserName = "admin_apiprodutos",
                        Email = "admin-apiprodutos@teste.com.br",
                        EmailConfirmed = true
                    }, "AdminAPIProdutos01!", roles);

                _accessManager.CreateUser(
                    new ApplicationUser()
                    {
                        UserName = "usrinvalido_apiprodutos",
                        Email = "usrinvalido-apiprodutos@teste.com.br",
                        EmailConfirmed = true
                    }, "UsrInvAPIProdutos01!", roles);
            }
        }
    }
}