From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] Locality support for tpm_crb
Date: Tue, 7 Mar 2017 20:31:38 +0200
Message-ID: <20170307183138.yjd3aobajntnsizg@intel.com>
References: <20170208111137.15153-1-jarkko.sakkinen@linux.intel.com>
	<87efydvnk8.fsf@snitselaar.org>
	<20170306153515.7hxoylfqfvy5rito@intel.com>
	<D0B11485C64D4B47B66902F8A4E901BE3B9AF0F7@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D0B11485C64D4B47B66902F8A4E901BE3B9AF0F7-E2R4CRU6q/6iAffOGbnezLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jerry Snitselaar <dev-RR6//3E8fTwgb5+hjvvj3w@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 07, 2017 at 04:41:04PM +0000, Wei, Gang wrote:
> On Mon, Mar 06, 2017 at 11:35 PM +0800, Jarkko Sakkinen wrote:
> > On Fri, Mar 03, 2017 at 06:27:19PM -0700, Jerry Snitselaar wrote:
> > >
> > > Jarkko Sakkinen @ 2017-02-08 11:11 GMT:
> > >
> > > > The tpm_crb driver should follow the policy of reserving and
> > > > relinquishing the locality it uses when multiple localities are
> > used,
> > > > like when TXT is another locality.
> > > >
> > > > [This is a resend of v3 as this has been asked from me for a few
> > times
> > > >  now and there wasn't anything obvious to fix.]
> > > >
> > > > Jarkko Sakkinen (3):
> > > >   tpm_crb: map locality registers
> > > >   tpm_crb: encapsulate crb_wait_for_reg_32
> > > >   tpm_crb: request and relinquish locality 0
> > > >
> > > >  drivers/char/tpm/tpm_crb.c | 185
> > +++++++++++++++++++++++++++++++++------------
> > > >  1 file changed, 137 insertions(+), 48 deletions(-)
> > >
> > > Reviewed-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Jimmy, can you give these patches Tested-by? I remember that
> > you said that they are working for you.
> 
> Sure. They did work for me.
> 
> Jimmy

Thank you!

/Jarkko

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
