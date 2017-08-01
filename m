From: George Wilson <ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: tpm: read burstcount from TPM_STS in one 32-bit
 transaction
Date: Tue, 1 Aug 2017 10:59:19 -0500
Message-ID: <20170801155919.GA26008@us.ibm.com>
References: <20170725150443.7cf8fc91@kitsune.suse.cz>
 <1501004171.3689.25.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501004171.3689.25.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 25, 2017 at 10:36:11AM -0700, James Bottomley wrote:
> On Tue, 2017-07-25 at 15:04 +0200, Michal Such=E1nek wrote:
> > Hello,
> > =

> > in commit 9754d45e9970 ("tpm: read burstcount from TPM_STS in one
> > 32-bit transaction") you change reading of two 8-bit values to one
> > 32bit read. This is obviously wrong wrt endianess unless the
> > underlying tpm_tis_read32 does endian conversion.=A0
> =

> Some of the bus read primitives do do endianness conversions. =A0The
> problem is with the SPI attachment, which has unclear endianness. =A0A
> standard PCI bus attachment uses ioread32() which automatically
> transforms from a little endian bus to the cpu endianness, however SPI
> is forced to transfer the bytes one at a time over the serial bus and
> then transform. =A0The assumption seems to be that the TIS TPM is
> replying in little endian format when SPI connected.
> =

> We can probably get the PPC people to confirm this, I believe they have
> a SPI attached TPM.

All the current OpenPOWER hardware designs I'm aware of have the TPM on
I2C.  Trusted Computing support in OpenPOWER firmware depends on it
being on I2C.

> =

> James
> =

> =

> -------------------------------------------------------------------------=
-----
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel


---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
