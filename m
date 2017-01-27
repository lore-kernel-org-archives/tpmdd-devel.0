From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Fri, 27 Jan 2017 08:42:40 +0200
Message-ID: <20170127064240.5xrf4ddbo2vq3llb@intel.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
	<20170124001918.GA29735@obsidianresearch.com>
	<20170124143600.siyhblj67qaatewi@intel.com>
	<20170124190707.GA9899@obsidianresearch.com>
	<20170125202137.7bsv7lptvpzl2fjz@intel.com>
	<20170125221136.GA713@obsidianresearch.com>
	<20170126111403.ql6np2qulifxxw3p@intel.com>
	<20170126180506.GA20330@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126180506.GA20330-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 26, 2017 at 11:05:06AM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 26, 2017 at 01:14:03PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Jan 25, 2017 at 03:11:36PM -0700, Jason Gunthorpe wrote:
> > > On Wed, Jan 25, 2017 at 10:21:37PM +0200, Jarkko Sakkinen wrote:
> > > 
> > > > There should be anyway someway to limit what commands can be sent but
> > > > I understand your point.
> > > 
> > > What is the filter for?
> > > 
> > > James and I talked about a filter to create a safer cdev for use by
> > > users. However tpms0 cannot be that 'safer' cdev - it is now the 'all
> > > access' path.
> > 
> > What do you mean by "safer cdev"?
> 
> 'safer cdev' is this concept of limiting privileges you are describing
> below.
> 
> > > I also suggested a filter in the kernel to ensure that the RM is only
> > > passing commands it actually knows it handles properly. eg you would
> > > filter out list handles. That is hardwired into the kernel, and does
> > > not ge to be configured by user space.
> >
> > In many cases you would want to limit the set of operations that client
> > can use.  For example, not every client needs NV operations. In general
> > you might want to have mechanism for limiting privileges. I haven't
> > really considered this from the perspective that you've been discussing
> > but more from the "principle of least privilege" perspective.
> 
> What does that mean? The kernel needs to provide an unrestricted
> access path to the TPM and the RM - typically for use by root. I don't
> think there is any debate on this point.
> 
> The kernel *could* provide restricted access to the TPM and the RM -
> typically for use by a user.
> 
> These are *different* things and they should not both exist at once on
> /dev/tpms0 (that is not the unix model).
> 
> IMHO this patch series should focus entirely on the unrestricted
> access path. Otherwise the debate is too large and complex.

Agreed. We can add more granular access control later on.

For the rest of the response I understand your point of view but lets
continue after we have basic building blocks in place :-)

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
