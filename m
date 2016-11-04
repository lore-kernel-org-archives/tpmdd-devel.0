From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 3/3] tpm: move documentation under Documentation/security
Date: Fri, 4 Nov 2016 07:01:02 -0600
Message-ID: <20161104130102.pm4ggspfbyemrx6u@intel.com>
References: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
 <20161103235752.19256-4-jarkko.sakkinen@linux.intel.com>
 <8760o3ih5j.fsf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8760o3ih5j.fsf@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Nov 04, 2016 at 02:06:00PM +0200, Jani Nikula wrote:
> On Fri, 04 Nov 2016, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > In order too make Documentation root directory cleaner move the tpm
> > directory under Documentation/security.
> 
> FWIW I like this.

Thx. I just realized that I should have CC'd to linux-security-module
to get say from James as this makes path for the whole security tree.

James, sorry about that. Can you share your opinion?

> BR,
> Jani.

/Jarkko

> 
> 
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  Documentation/index.rst                             | 2 +-
> >  Documentation/security/index.rst                    | 7 +++++++
> >  Documentation/{ => security}/tpm/index.rst          | 0
> >  Documentation/{ => security}/tpm/tpm_vtpm_proxy.rst | 0
> >  Documentation/{ => security}/tpm/xen-tpmfront.txt   | 0
> >  5 files changed, 8 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/security/index.rst
> >  rename Documentation/{ => security}/tpm/index.rst (100%)
> >  rename Documentation/{ => security}/tpm/tpm_vtpm_proxy.rst (100%)
> >  rename Documentation/{ => security}/tpm/xen-tpmfront.txt (100%)
> >
> > diff --git a/Documentation/index.rst b/Documentation/index.rst
> > index 0058b65..b4c3034 100644
> > --- a/Documentation/index.rst
> > +++ b/Documentation/index.rst
> > @@ -19,7 +19,7 @@ Contents:
> >     media/dvb-drivers/index
> >     media/v4l-drivers/index
> >     gpu/index
> > -   tpm/index
> > +   security/index
> >  
> >  Indices and tables
> >  ==================
> > diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
> > new file mode 100644
> > index 0000000..9bae6bb
> > --- /dev/null
> > +++ b/Documentation/security/index.rst
> > @@ -0,0 +1,7 @@
> > +======================
> > +Security documentation
> > +======================
> > +
> > +.. toctree::
> > +
> > +   tpm/index
> > diff --git a/Documentation/tpm/index.rst b/Documentation/security/tpm/index.rst
> > similarity index 100%
> > rename from Documentation/tpm/index.rst
> > rename to Documentation/security/tpm/index.rst
> > diff --git a/Documentation/tpm/tpm_vtpm_proxy.rst b/Documentation/security/tpm/tpm_vtpm_proxy.rst
> > similarity index 100%
> > rename from Documentation/tpm/tpm_vtpm_proxy.rst
> > rename to Documentation/security/tpm/tpm_vtpm_proxy.rst
> > diff --git a/Documentation/tpm/xen-tpmfront.txt b/Documentation/security/tpm/xen-tpmfront.txt
> > similarity index 100%
> > rename from Documentation/tpm/xen-tpmfront.txt
> > rename to Documentation/security/tpm/xen-tpmfront.txt
> 
> -- 
> Jani Nikula, Intel Open Source Technology Center
