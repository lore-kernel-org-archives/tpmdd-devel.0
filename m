From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] Documentation: tpm: add the Physical TPM device
 tree binding documentation
Date: Fri, 4 Nov 2016 01:32:31 -0600
Message-ID: <20161104073231.jgkii6yhp4udity6@intel.com>
References: <1477473705-12746-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1477473705-12746-2-git-send-email-nayna@linux.vnet.ibm.com>
 <20161031040245.cwnt4kelrm7liaga@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161031040245.cwnt4kelrm7liaga@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hellerda-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, cclaudio-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 30, 2016 at 11:02:45PM -0500, Rob Herring wrote:
> On Wed, Oct 26, 2016 at 05:21:45AM -0400, Nayna Jain wrote:
> > Newly added support of TPM 2.0 eventlog securityfs pseudo files in tpm
> > device driver consumes device tree bindings representing I2C based
> > Physical TPM. This patch adds the documentation for corresponding device
> > tree bindings of I2C based Physical TPM. These bindings are similar to
> > vtpm device tree bindings being used on IBM Power7+ and Power8 Systems
> > running PowerVM.
> > 
> > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> > Changelog v3:
> >  - Added documentation for "label" property.
> > 
> > Changelog v2:
> > 
> > - Include review feedbacks.
> >   - Move the doc within bindings/security/tpm.
> >   - Add example for compatible property in description.
> >   - Delete implicit properties like status, label from description.
> >   - Redefine linux,sml-base description.
> > 
> >  .../devicetree/bindings/security/tpm/tpm-i2c.txt    | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> 
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied.

/Jarkko
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
