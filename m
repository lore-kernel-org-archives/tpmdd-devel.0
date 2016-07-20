From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: add driver for cr50 on SPI
Date: Tue, 19 Jul 2016 17:24:11 -0700
Message-ID: <20160720002411.GA147098@apronin>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
	<1468549218-19215-3-git-send-email-apronin@chromium.org>
	<20160715033236.GH9347@obsidianresearch.com>
	<20160715034444.GA28128@apronin> <20160719125527.GB5047@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160719125527.GB5047-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 03:55:27PM +0300, Jarkko Sakkinen wrote:
> On Thu, Jul 14, 2016 at 08:44:44PM -0700, Andrey Pronin wrote:
> > On Thu, Jul 14, 2016 at 09:32:36PM -0600, Jason Gunthorpe wrote:
> > > On Thu, Jul 14, 2016 at 07:20:18PM -0700, Andrey Pronin wrote:
> > > 
> > > > +static int cr50_spi_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
> > > > +{
> > > > +	int rc;
> > > > +
> > > > +	rc = data->phy_ops->read_bytes(data, addr, sizeof(u16), (u8 *)result);
> > > > +	if (!rc)
> > > > +		*result = le16_to_cpu(*result);
> > > > +	return rc;
> > > > +}
> > > 
> > > I thought we had core support for this pattern?
> > > 
> > > Christophe ?
> > > 
> > > Please change this so this code isn't duplicated.
> > > 
> > > Jason
> > >
> > Hmm, didn't see the support. Would be great if there is.
> > The pattern itself is copied from tpm_tis_spi as is.
> > read_bytes/write_bytes were de-dup'ed as they used a lot of common code
> > (even more for this driver than for tpm_tis_spi).
> > But as for _readNN/_writeNN, there're only three of these functions,
> > so it din't seem too bad.
> 
> If there isn't, please add a separate commit before this that adds an
> inline function to tpm_tis_core.h.
>
tpm_tis_core.h currently has access functions defined like:
static inline int tpm_tis_read16(struct tpm_tis_data *data, u32 addr,
                                 u16 *result)
{
        return data->phy_ops->read16(data, addr, result);
}

And it's up to the drivers implementing phy_ops to do (or not)
byte-swapping as necessary before/after IO ops. For example,
tpm_tis.c in its phy_ops->read16 simply does ioread16(), while
tpm_tis_spi.c (and cr50_spi.c) does phy_ops->read_bytes()
followed by le16_to_cpu().

Still, I can create add'l inline functions:
static inline int tpm_tis_read_le16(struct tpm_tis_data *data,
                                    u32 addr, u16 *result)
{
	int rc;

	rc = data->phy_ops->read_bytes(data, addr,
				       sizeof(u16), (u8 *)result);
	if (!rc)
		*result = le16_to_cpu(*result);
	return rc;
}
and re-use them both in cr50_spi.c and tpm_tis_spi.c

The only two things that bother me with such approach are
(1) whatever names I pick for the new set of functions, they
    will be similar to and thus might be confused with the
    original tpm_tis_read/writeXX;
(2) these functions are phy-specific, so possibly it's better
    to create tpm_tis_spi.h and put them there with proper
    name prefixes. And then use in tpm_tis_spi and cr50_spi.

Any preferences on what I should better do?

Andrey

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
