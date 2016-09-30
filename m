From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/8] tpm: replace dynamically allocated
 bios_dir with dentry array
Date: Fri, 30 Sep 2016 22:48:25 +0300
Message-ID: <20160930194825.GB12710@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20160930182703.GA9595@intel.com>
	<20160930183026.GC1867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160930183026.GC1867-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Fri, Sep 30, 2016 at 12:30:26PM -0600, Jason Gunthorpe wrote:
> On Fri, Sep 30, 2016 at 09:27:03PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Sep 28, 2016 at 04:34:36AM -0400, Nayna Jain wrote:
> 
> > > -	struct dentry **bios_dir;
> > > +	struct dentry *bios_dir[3];
> > > +	unsigned int bios_dir_count;
> > 
> > You should rather have a four entry array and use a NULL terminator.
> 
> Why? Then everything has to compute the length before doing
> anything. The basic ops are 'append to back' and 'pop off back' which
> require length.

One variable less to struct tpm_chip. The loop that removes the files
simply can continue until NULL is encountered.

Where do you need the length?

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
