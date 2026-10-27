using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using wpAspNet.Data;
using wpAspNet.Models;
using wpAspNet.ViewModels;

namespace wpAspNet.Controllers
{
    
    [Authorize]
    public class FilesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public FilesController(ApplicationDbContext context)
        {
            _context = context;
        }
        
        public async Task<IActionResult> Index()
        {
            var multimediaFiles = await _context.MultimediaFile.ToListAsync();
            var genres = await _context.MultimediaFile
                .Select(m => m.Genre)
                .Distinct()
                .ToListAsync();

            var viewModel = new MultimediaFileIndexViewModel
            {
                MultimediaFiles = multimediaFiles,
                Genres = genres
            };

            return View(viewModel);
           
        }
        public async Task<IActionResult> ByGenre(string genre)
        {
            if (string.IsNullOrEmpty(genre) || genre == "All")
            {
                var multimediaFiles = await _context.MultimediaFile.ToListAsync();
                var viewModel = new MultimediaFileIndexViewModel
                {
                    MultimediaFiles = multimediaFiles,
                    Genres = await _context.MultimediaFile
                        .Select(m => m.Genre)
                        .Distinct()
                        .ToListAsync()
                };
                
                return PartialView("_MultimediaFileTable", viewModel);
            }
            
            var filesByGenre = await _context.MultimediaFile
                .Where(m => m.Genre == genre)
                .ToListAsync();
            
            var viewModelByGenre = new MultimediaFileIndexViewModel
            {
                MultimediaFiles = filesByGenre,
                Genres = await _context.MultimediaFile
                    .Select(m => m.Genre)
                    .Distinct()
                    .ToListAsync()
            };
            
            return PartialView("_MultimediaFileTable", viewModelByGenre);
        }
        
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var multimediaFile = await _context.MultimediaFile
                .FirstOrDefaultAsync(m => m.Id == id);
            if (multimediaFile == null)
            {
                return NotFound();
            }

            return View(multimediaFile);
        }
        public IActionResult Create()
        {
            return View();
        }
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Title,FormatType,Genre,Path")] MultimediaFile multimediaFile)
        {
            if (ModelState.IsValid)
            {
                _context.Add(multimediaFile);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(multimediaFile);
        }
        
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var multimediaFile = await _context.MultimediaFile.FindAsync(id);
            if (multimediaFile == null)
            {
                return NotFound();
            }
            return View(multimediaFile);
        }
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Title,FormatType,Genre,Path")] MultimediaFile multimediaFile)
        {
            if (id != multimediaFile.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(multimediaFile);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!MultimediaFileExists(multimediaFile.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(multimediaFile);
        }
        
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var multimediaFile = await _context.MultimediaFile
                .FirstOrDefaultAsync(m => m.Id == id);
            if (multimediaFile == null)
            {
                return NotFound();
            }

            return View(multimediaFile);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var multimediaFile = await _context.MultimediaFile.FindAsync(id);
            if (multimediaFile != null)
            {
                _context.MultimediaFile.Remove(multimediaFile);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool MultimediaFileExists(int id)
        {
            return _context.MultimediaFile.Any(e => e.Id == id);
        }
    }
}
