From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/4] tpm: add kdoc for tpm_transmit and
	tpm_transmit_cmd
Date: Tue, 22 Nov 2016 12:19:02 +0200
Message-ID: <20161122101902.mkjoaajjvicd7ia5@intel.com>
References: <1479315821-27349-1-git-send-email-tomas.winkler@intel.com>
	<20161116230016.iyiht373fefu6xt2@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B5432F79C@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5432F79C-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 22, 2016 at 09:44:20AM +0000, Winkler, Tomas wrote:
> > 
> > On Wed, Nov 16, 2016 at 07:03:38PM +0200, Tomas Winkler wrote:
> > > Functions tpm_transmit and transmit_cmd are referenced from other
> > > functions kdoc hence deserve documentation.
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Do you know how to make "make htmldocs" to generate documentation for the
> > source tree? I do not except the ones that I imported when I created an RST
> > version of the Stefans documentation.
> 
> I'm using a quick script like that
> RES=tpm-kdoc.html
> rm -r $RES kdoc.err
> files=$(git ls-files drivers/char/tpm/*.[ch] includ/linux/tpm.h includ/linux/tpm_command.h)
> 
> echo '<html>' > $RES
> for f in ${files}; do
>         ./scripts/kernel-doc -html $f >> $RES 2>> kdoc.err
> done
> echo '</html>' >> $RES
> cat kdoc.err | grep -v 'warning: no structured comments found'

Thanks. I'll try this as soon as the release chaos is over.

/Jarkko

------------------------------------------------------------------------------
