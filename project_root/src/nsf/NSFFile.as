package nsf 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class NSFFile extends Object 
	{
		static public function Load(source:Class):NSFFile
		{
			var nsfFile:NSFFile = new NSFFile;
			if (!nsfFile.Load(source))
			{
				return null;
			}
			return nsfFile;
		}
		
		// holds the entire nsf file
		private var nsfBytes:ByteArray;
		
		// basic nsf information
		
		// address where the nsf is loaded to
		private var loadAddress:uint;
		
		// address of the init routine
		private var initAddress:uint;
		
		// address of the play routine
		private var playAddress:uint;
		
		// extra sound chip support bitmask
		private var chips:uint;
		
		private var usePal:Boolean;
		
		// play speeds
		private var ntscPlaySpeed:uint;
		private var palPlaySpeed:uint;
		
		// number of tracks
		private var trackCount:uint;
		
		// first track
		private var firstTrack:uint;
		
		// data buffer 
		private var data:ByteArray;
		private var dataSize:uint;
		
		// strings
		private var gameTitle:String;
		private var author:String;
		private var copyright:String;
		
		// bank switching info
		private var bs0:uint;
		private var bs1:uint;
		private var bs2:uint;
		private var bs3:uint;
		private var bs4:uint;
		private var bs5:uint;
		private var bs6:uint;
		private var bs7:uint;
		
		public function NSFFile() {}
		
		public function Load(source:Class):Boolean
		{
			nsfBytes = ByteArray(new source);
			trace("Loading NSF...", nsfBytes.length, "bytes loaded.");
			
			// only support NESM NSF files
			var format:ByteArray = new ByteArray;
			nsfBytes.readBytes(format, 0, 4);
			if (format.toString() != "NESM")
			{
				return false;
			}
			
			LoadNESM();
			
			return true;
		}
		
		private function LoadNESM():void
		{
			var len:uint = nsfBytes.length - 0x80;
			if (len < 1) { throw new Error("Error: NSF Length is 0"); }
			
			var header:ByteArray = new ByteArray;
			nsfBytes.position = 0;
			nsfBytes.readBytes(header, 0, 0x80);
			
			var format:String = header.readUTFBytes(4);
			var fmtExtra:uint = header.readUnsignedByte();
			if (fmtExtra != 0x1A)
			{
				throw new Error("Error: NSF format is invalid:", fmtExtra);
			}
			
			var version:uint = header.readUnsignedByte();
			if (version != 0x01)
			{
				throw new Error("Error: NSF version is invalid:", version);
			}
			
			trackCount = header.readUnsignedByte();
			firstTrack = header.readUnsignedByte();
			loadAddress = header.readUnsignedShort();
			initAddress = header.readUnsignedShort();
			playAddress = header.readUnsignedShort();
			gameTitle = header.readUTFBytes(32);
			author = header.readUTFBytes(32);
			copyright = header.readUTFBytes(32);
			ntscPlaySpeed = header.readUnsignedShort();
			bs0 = header.readUnsignedByte();
			bs1 = header.readUnsignedByte();
			bs2 = header.readUnsignedByte();
			bs3 = header.readUnsignedByte();
			bs4 = header.readUnsignedByte();
			bs5 = header.readUnsignedByte();
			bs6 = header.readUnsignedByte();
			bs7 = header.readUnsignedByte();
			palPlaySpeed = header.readUnsignedShort();
			usePal = (0x03 == (header.readUnsignedByte() & 0x03));
			chips = header.readUnsignedByte();
			
			data = new ByteArray;
			nsfBytes.position = 0;
			nsfBytes.readBytes(data, 0, len);
			dataSize = len;
			
			trace(
				"Header:\n\n",
				"Format:", format + fmtExtra.toString(16).toUpperCase(), "\n",
				"Version:", version, "\n",
				"Track Count:", trackCount, "\n",
				"First Track:", firstTrack, "\n",
				"Load Address:", "0x" + loadAddress.toString(16).toUpperCase(), "\n",
				"Init Address:", "0x" + initAddress.toString(16).toUpperCase(), "\n",
				"Play Address:", "0x" + playAddress.toString(16).toUpperCase(), "\n",
				"Game Title:", gameTitle, "\n",
				"NSF Author:", author, "\n",
				"Copyright:", copyright, "\n",
				"NTSC Play Speed:", ntscPlaySpeed, "\n",
				"PAL Play Speed:", palPlaySpeed, "\n",
				"Is PAL NSF:", usePal, "\n",
				"Bank Switches: ",
				bs0,bs1,bs2,bs3,bs4,bs5,bs6,bs7,"\n",
				"Extensions:\n",
				"VRCVI:", ((chips & 0x01) ? "YES" : "NO"), "\n", 
				"VRCVII:", ((chips & 0x02) ? "YES" : "NO"), "\n", 
				"FDS Sound:", ((chips & 0x04) ? "YES" : "NO"), "\n", 
				"MMC5 audio:", ((chips & 0x08) ? "YES" : "NO"), "\n", 
				"Namco 106:", ((chips & 0x10) ? "YES" : "NO"), "\n", 
				"Sunsoft FME-07:", ((chips & 0x20) ? "YES" : "NO"), "\n\n",
				"Music Data Length:",dataSize);
		}
		
	}
}