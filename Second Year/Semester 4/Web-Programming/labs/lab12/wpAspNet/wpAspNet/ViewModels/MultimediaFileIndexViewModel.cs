using wpAspNet.Models;

namespace wpAspNet.ViewModels;
public class MultimediaFileIndexViewModel
{
    public IEnumerable<MultimediaFile> MultimediaFiles { get; set; }
    public IEnumerable<string> Genres { get; set; }
}