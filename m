From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: Atmel I2C TPM transfer length issues
Date: Tue, 14 Feb 2017 09:39:30 +0100
Message-ID: <A6C9A409-4FF4-41A7-AE4F-0727B1464447@gmx.de>
References: <20170214023336.GC21340@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170214023336.GC21340-g2DYL2Zd6BY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



Am 14. Februar 2017 03:33:36 MEZ schrieb Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>:
>Hi Jason
>
>I'm hoping you can help me with an issue i have with an ATMEL I2C
>TPM. I have one connected to an DLN2 USB-I2C bus controller. Initial
>probe works, i can get the capabilites in /sys/class/tpm/tpm0,
>tpm_version etc:
>
>/sys/class/tpm/tpm0# cat caps 
>Manufacturer: 0x41544d4c
>TCG version: 1.2
>Firmware version: 66.4
>
>But i have issues with pubek and other long i2c transfers:
>
>/sys/class/tpm/tpm0# hexdump pubek
>[11621.731960] i2c i2c-11: adapter quirk: msg too long (addr 0x0029,
>size 314, read)
>[11621.738208] tpm tpm0: tpm_transmit: tpm_recv: error -95
>
>The dln2 i2c bus controller has a transfer limit of 256 bytes. Getting
>the pubek is doing a read for 314 bytes, which is getting rejected.
>
>Is there any way to fragment the reads/writes? Looking at
>tpm_i2c_atmel i don't see any. It seems the raw TCG commands need to
>be passed in a single i2c transaction. The comment in i2c_atmel_recv()
>suggests that multiple reads will always start from the beginning of
>the TCG response. There are no comments in the send function, but i
>guess an I2C start condition indicates the start of a new command?
>
>Or am i missing something?
>
>Can fragmentation happen at a higher layer?
>
>Any other ideas?

Just limit the value which get_burstcount() returns to 256.
This should do the trick - because that would be the mechanism the tpm itself would use to fragment its response.
Atleast for other tpms like our infineon slb9645 i2c tpm that would work.


>
>Thanks
>	Andrew
>
>------------------------------------------------------------------------------
>Check out the vibrant tech community on one of the world's most
>engaging tech sites, SlashDot.org! http://sdm.link/slashdot
>_______________________________________________
>tpmdd-devel mailing list
>tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
