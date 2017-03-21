using Newtonsoft.Json;
using System.IO;
using System.Text;

namespace StressMeOut
{
	class Settings
	{
		public int Delay { get; set; } = 10;
		public int MaxConcurrency { get; set; } = int.MaxValue;
		public string Endpoint { get; set; }


		private const string FILE_PATH = @"\save.ini";
		public void Save()
		{
			if (File.Exists(FILE_PATH))
				File.Delete(FILE_PATH);

			using (var fs = File.Create(FILE_PATH))
			{
				var info = new UTF8Encoding(true).GetBytes(JsonConvert.SerializeObject(this));
				fs.Write(info, 0, info.Length);
			}

		}

		public static Settings Load()
		{
			if (!File.Exists(FILE_PATH))
				return new Settings();

			// Open the stream and read it back.
			using (var sr = File.OpenText(FILE_PATH))
			{
				var config = sr.ReadToEnd();
				var settings = JsonConvert.DeserializeObject<Settings>(config);
				return settings;
			}

		}
	}
}
