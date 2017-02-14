From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Atmel I2C TPM transfer length issues
Date: Tue, 14 Feb 2017 10:37:17 -0700
Message-ID: <20170214173717.GA3060@obsidianresearch.com>
References: <20170214023336.GC21340@lunn.ch>
	<A6C9A409-4FF4-41A7-AE4F-0727B1464447@gmx.de>
	<20170214130511.GA32480@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170214130511.GA32480-g2DYL2Zd6BY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 14, 2017 at 02:05:11PM +0100, Andrew Lunn wrote:
> > Just limit the value which get_burstcount() returns to 256.
> >
> > This should do the trick - because that would be the mechanism the
> > tpm itself would use to fragment its response.  Atleast for other
> > tpms like our infineon slb9645 i2c tpm that would work.
> 
> Yes, that was one idea i had. But then i found the comment on the top
> of tpm_i2c_atmel:
> 
>  * Teddy Reed determined the basic I2C command flow, unlike other I2C TPM
>  * devices the raw TCG formatted TPM command data is written via I2C and then
>  * raw TCG formatted TPM command data is returned via I2C.
> 
> The driver does not do anything like read the burst size and then
> transfer in blocks. It reads/writes all in one go.

Yes, as far as I know, there is no option to do a smaller I2C read,
the I2C controller must support large reads. Future reads return the
first bytes of the message and I know of no way to offset the read.

> However, you have answered what was going to be a follow question. The
> hardware is not yet set in stone. We could change the TPM. Use the
> Infinion TPM with a modified get_burstcount(). And you think this will
> work. Great.

FWIW, on all our hardware we design for 2-3 different TPMs because
they are a bit difficult to get. There is now a new TCG specification
for I2C and SPI connected TPMs, so there may be better choices for
compatability.

IIRC, our alt for the atmel i2c part is a nuvoton part.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
