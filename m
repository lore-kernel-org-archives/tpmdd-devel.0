From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: transition tpm_vtpm_proxy
 documentation to the Sphinx
Date: Thu, 3 Nov 2016 06:57:12 -0600
Message-ID: <20161103125712.qrjlabme5r3lupjy@intel.com>
References: <20161102180207.16583-1-jarkko.sakkinen@linux.intel.com>
	<874m3pj7n3.fsf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <874m3pj7n3.fsf-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 03, 2016 at 10:21:36AM +0200, Jani Nikula wrote:
> On Wed, 02 Nov 2016, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > Transitioned the tpm_vtpm_proxy documentation to the Sphinx
> > infrastructure and removed parts from the documentation that are easier
> > to pull from the sources. Restructured vtpm_proxy.h and tpm_vtpm_proxy.c
> > to be compatible with this approach and wrote associated documentation
> > comments.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  Documentation/index.rst                            |  1 +
> >  Documentation/tpm/index.rst                        |  7 +++
> >  .../tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} | 53 +++++-----------
> >  drivers/char/tpm/tpm_vtpm_proxy.c                  | 72 ++++++++++++++--------
> >  include/uapi/linux/vtpm_proxy.h                    | 23 +++++--
> 
> I'm not sure it's a good idea to combine this much code change with the
> documentation change. Perhaps split up, at least the function
> movement/abstraction bits?

Sure. I scraped this up quickly to get some feedback whether I'm doing
this right at all :-)

> 
> >  5 files changed, 89 insertions(+), 67 deletions(-)
> >  create mode 100644 Documentation/tpm/index.rst
> >  rename Documentation/tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} (56%)
> >
> > diff --git a/Documentation/index.rst b/Documentation/index.rst
> > index e0fc729..0058b65 100644
> > --- a/Documentation/index.rst
> > +++ b/Documentation/index.rst
> > @@ -19,6 +19,7 @@ Contents:
> >     media/dvb-drivers/index
> >     media/v4l-drivers/index
> >     gpu/index
> > +   tpm/index
> >  
> >  Indices and tables
> >  ==================
> > diff --git a/Documentation/tpm/index.rst b/Documentation/tpm/index.rst
> > new file mode 100644
> > index 0000000..316cdbb
> > --- /dev/null
> > +++ b/Documentation/tpm/index.rst
> > @@ -0,0 +1,7 @@
> > +=================
> > +TPM documentation
> > +=================
> 
> This will pop up at the top level of the documentation. I'm not saying
> that's necessarily wrong per se, but IMO you should spell out Trusted
> Platform Module here instead of just using the acronym.
> 
> (Sure we have "GPU" at the top level, but I think that's a better known
> acronym. And we might change that to "Graphics" anyway.)

Got you. I'll change it to Trusted Platform Module.

> BR,
> Jani.
> 
> 
> -- 
> Jani Nikula, Intel Open Source Technology Center

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
