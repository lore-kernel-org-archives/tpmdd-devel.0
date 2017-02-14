From: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Subject: Atmel I2C TPM transfer length issues
Date: Tue, 14 Feb 2017 03:33:36 +0100
Message-ID: <20170214023336.GC21340@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason

I'm hoping you can help me with an issue i have with an ATMEL I2C
TPM. I have one connected to an DLN2 USB-I2C bus controller. Initial
probe works, i can get the capabilites in /sys/class/tpm/tpm0,
tpm_version etc:

/sys/class/tpm/tpm0# cat caps 
Manufacturer: 0x41544d4c
TCG version: 1.2
Firmware version: 66.4

But i have issues with pubek and other long i2c transfers:

/sys/class/tpm/tpm0# hexdump pubek
[11621.731960] i2c i2c-11: adapter quirk: msg too long (addr 0x0029, size 314, read)
[11621.738208] tpm tpm0: tpm_transmit: tpm_recv: error -95

The dln2 i2c bus controller has a transfer limit of 256 bytes. Getting
the pubek is doing a read for 314 bytes, which is getting rejected.

Is there any way to fragment the reads/writes? Looking at
tpm_i2c_atmel i don't see any. It seems the raw TCG commands need to
be passed in a single i2c transaction. The comment in i2c_atmel_recv()
suggests that multiple reads will always start from the beginning of
the TCG response. There are no comments in the send function, but i
guess an I2C start condition indicates the start of a new command?

Or am i missing something?

Can fragmentation happen at a higher layer?

Any other ideas?

Thanks
	Andrew

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
