From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH] tpm: transition tpm_vtpm_proxy documentation to the Sphinx
Date: Thu, 03 Nov 2016 10:21:36 +0200
Message-ID: <874m3pj7n3.fsf@intel.com>
References: <20161102180207.16583-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161102180207.16583-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 02 Nov 2016, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> Transitioned the tpm_vtpm_proxy documentation to the Sphinx
> infrastructure and removed parts from the documentation that are easier
> to pull from the sources. Restructured vtpm_proxy.h and tpm_vtpm_proxy.c
> to be compatible with this approach and wrote associated documentation
> comments.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  Documentation/index.rst                            |  1 +
>  Documentation/tpm/index.rst                        |  7 +++
>  .../tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} | 53 +++++-----------
>  drivers/char/tpm/tpm_vtpm_proxy.c                  | 72 ++++++++++++++--------
>  include/uapi/linux/vtpm_proxy.h                    | 23 +++++--

I'm not sure it's a good idea to combine this much code change with the
documentation change. Perhaps split up, at least the function
movement/abstraction bits?

>  5 files changed, 89 insertions(+), 67 deletions(-)
>  create mode 100644 Documentation/tpm/index.rst
>  rename Documentation/tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} (56%)
>
> diff --git a/Documentation/index.rst b/Documentation/index.rst
> index e0fc729..0058b65 100644
> --- a/Documentation/index.rst
> +++ b/Documentation/index.rst
> @@ -19,6 +19,7 @@ Contents:
>     media/dvb-drivers/index
>     media/v4l-drivers/index
>     gpu/index
> +   tpm/index
>  
>  Indices and tables
>  ==================
> diff --git a/Documentation/tpm/index.rst b/Documentation/tpm/index.rst
> new file mode 100644
> index 0000000..316cdbb
> --- /dev/null
> +++ b/Documentation/tpm/index.rst
> @@ -0,0 +1,7 @@
> +=================
> +TPM documentation
> +=================

This will pop up at the top level of the documentation. I'm not saying
that's necessarily wrong per se, but IMO you should spell out Trusted
Platform Module here instead of just using the acronym.

(Sure we have "GPU" at the top level, but I think that's a better known
acronym. And we might change that to "Graphics" anyway.)

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
