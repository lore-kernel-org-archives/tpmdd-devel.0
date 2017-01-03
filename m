From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 4/4] tpm: add the infrastructure for
 TPM space for TPM 2.0
Date: Tue, 3 Jan 2017 12:16:34 -0700
Message-ID: <20170103191634.GC26706@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-5-jarkko.sakkinen@linux.intel.com>
	<20170102210953.GB5544@obsidianresearch.com>
	<20170103003730.he32vl55kkta2q64@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170103003730.he32vl55kkta2q64-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 02:37:30AM +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 02, 2017 at 02:09:53PM -0700, Jason Gunthorpe wrote:
> > On Mon, Jan 02, 2017 at 03:22:10PM +0200, Jarkko Sakkinen wrote:
> > > Added a ioctl for creating a TPM space. The space is isolated from the
> > > other users of the TPM. Only a process holding the file with the handle
> > > can access the objects and only objects that are created through that
> > > file handle can be accessed.
> > 
> > I don't understand this comment. /dev/tpmX is forced to be
> > single-process-open, so how can there ever be more than 1 FD for it?
> > 
> > Since the space is tied to that single fd these patches just create a
> > way for the single user-space process to auto-cleanup if it crashes?
> > 
> > Is that the entire intent of this design? I guess it is OK as a
> > stepping point..
> 
> is_open is cleared in tpm_ioc_new_space.

There is also a bug with the uncondtional clear of is_open in
tpm_release - this cannot happen if the ioctl is done - but I think
this approach of using an ioctl is not a good idea.

I have pondered using an open flag in the past - what about using
something like O_EXCL to indicate that the fd is to be used in
resource sharing mode? Not sure if that would be considered abuse of
the open flags or not.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
