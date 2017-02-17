From: Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
Subject: Re: tpmdd-devel Digest, Vol 110, Issue 19
Date: Fri, 17 Feb 2017 15:20:02 +0000
Message-ID: <f60e26ea3ca54a8f964b98c49089ac37@SFHDAG3NODE3.st.com>
References: <mailman.106650.1487261436.2424.tpmdd-devel@lists.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <mailman.106650.1487261436.2424.tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarko,

For your information : =


   1. [PATCH 4/5] tpm_tis_spi: Remove limitation of	transfers to
      MAX_SPI_FRAMESIZE bytes (Peter Huewe)  =

	Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
   2. [PATCH 0/5] Fix whole native SPI TPM driver (Peter Huewe)
	Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
   3. [PATCH 1/5] tpm_tis_spi: Use single function to	transfer data
      (Peter Huewe)
	Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
   4. [PATCH 2/5] tpm_tis_spi: Abort transfer when too many	wait
      states are signaled (Peter Huewe)
	Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
   5. [PATCH 3/5] tpm_tis_spi: Check correct byte for wait	state
      indicator (Peter Huewe)
	Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
   6. [PATCH 5/5] tpm_tis_spi: Add small delay after last	transfer
      (Peter Huewe)
	Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>


Best Regards,

Benoit
-----Original Message-----
From: tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org [mailto:tpmdd-devel-request=
@lists.sourceforge.net] =

Sent: jeudi 16 f=E9vrier 2017 17:11
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: tpmdd-devel Digest, Vol 110, Issue 19

Send tpmdd-devel mailing list submissions to
	tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org

To subscribe or unsubscribe via the World Wide Web, visit
	https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
or, via email, send a message with subject or body 'help' to
	tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org

You can reach the person managing the list at
	tpmdd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org

When replying, please edit your Subject line so it is more specific than "R=
e: Contents of tpmdd-devel digest..."


Today's Topics:

   1. [PATCH 4/5] tpm_tis_spi: Remove limitation of	transfers to
      MAX_SPI_FRAMESIZE bytes (Peter Huewe) =

   2. [PATCH 0/5] Fix whole native SPI TPM driver (Peter Huewe)
   3. [PATCH 1/5] tpm_tis_spi: Use single function to	transfer data
      (Peter Huewe)
   4. [PATCH 2/5] tpm_tis_spi: Abort transfer when too many	wait
      states are signaled (Peter Huewe)
   5. [PATCH 3/5] tpm_tis_spi: Check correct byte for wait	state
      indicator (Peter Huewe)
   6. [PATCH 5/5] tpm_tis_spi: Add small delay after last	transfer
      (Peter Huewe)


----------------------------------------------------------------------

Message: 1
Date: Thu, 16 Feb 2017 16:08:25 +0000
From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [tpmdd-devel] [PATCH 4/5] tpm_tis_spi: Remove limitation of
	transfers to MAX_SPI_FRAMESIZE bytes
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,	Christophe Ricard
	<christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Peter	Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>,
	Alexander
Message-ID:
	<1487261306-2494-5-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Content-Type: text/plain

Limiting transfers to MAX_SPI_FRAMESIZE was not expected by the upper layer=
s, as tpm_tis has no such limitation. Add a loop to hide that limitation.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 108 ++++++++++++++++++++++---------------=
----
 1 file changed, 57 insertions(+), 51 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.=
c index 16938e2253d2..b50c5b072df3 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -61,68 +61,74 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *da=
ta, u32 addr, u8 len,  {
 	struct tpm_tis_spi_phy *phy =3D to_tpm_tis_spi_phy(data);
 	int ret;
-	struct spi_message m;
-	struct spi_transfer spi_xfer =3D {
-		.tx_buf =3D phy->tx_buf,
-		.rx_buf =3D phy->rx_buf,
-		.len =3D 4,
-		.cs_change =3D 1,
-	};
-
-	if (len > MAX_SPI_FRAMESIZE)
-		return -ENOMEM;
 =

-	phy->tx_buf[0] =3D direction | (len - 1);
-	phy->tx_buf[1] =3D 0xd4;
-	phy->tx_buf[2] =3D addr >> 8;
-	phy->tx_buf[3] =3D addr;
+	spi_bus_lock(phy->spi_device->master);
 =

-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
+	while (len) {
+		struct spi_message m;
+		struct spi_transfer spi_xfer =3D {
+			.tx_buf =3D phy->tx_buf,
+			.rx_buf =3D phy->rx_buf,
+			.len =3D 4,
+			.cs_change =3D 1,
+		};
+		u8 transfer_len =3D min_t(u16, len, MAX_SPI_FRAMESIZE);
+
+		phy->tx_buf[0] =3D direction | (transfer_len - 1);
+		phy->tx_buf[1] =3D 0xd4;
+		phy->tx_buf[2] =3D addr >> 8;
+		phy->tx_buf[3] =3D addr;
+
+		spi_message_init(&m);
+		spi_message_add_tail(&spi_xfer, &m);
+		ret =3D spi_sync_locked(phy->spi_device, &m);
+		if (ret < 0)
+			goto exit;
 =

-	spi_bus_lock(phy->spi_device->master);
-	ret =3D spi_sync_locked(phy->spi_device, &m);
-	if (ret < 0)
-		goto exit;
-
-	if ((phy->rx_buf[3] & 0x01) =3D=3D 0) {
-		// handle SPI wait states
-		int i;
-
-		phy->tx_buf[0] =3D 0;
-
-		for (i =3D 0; i < TPM_RETRY; i++) {
-			spi_xfer.len =3D 1;
-			spi_message_init(&m);
-			spi_message_add_tail(&spi_xfer, &m);
-			ret =3D spi_sync_locked(phy->spi_device, &m);
-			if (ret < 0)
+		if ((phy->rx_buf[3] & 0x01) =3D=3D 0) {
+			// handle SPI wait states
+			int i;
+
+			phy->tx_buf[0] =3D 0;
+
+			for (i =3D 0; i < TPM_RETRY; i++) {
+				spi_xfer.len =3D 1;
+				spi_message_init(&m);
+				spi_message_add_tail(&spi_xfer, &m);
+				ret =3D spi_sync_locked(phy->spi_device, &m);
+				if (ret < 0)
+					goto exit;
+				if (phy->rx_buf[0] & 0x01)
+					break;
+			}
+
+			if (i =3D=3D TPM_RETRY) {
+				ret =3D -ETIMEDOUT;
 				goto exit;
-			if (phy->rx_buf[0] & 0x01)
-				break;
+			}
 		}
 =

-		if (i =3D=3D TPM_RETRY) {
-			ret =3D -ETIMEDOUT;
-			goto exit;
+		spi_xfer.cs_change =3D 0;
+		spi_xfer.len =3D transfer_len;
+
+		if (direction) {
+			spi_xfer.tx_buf =3D NULL;
+			spi_xfer.rx_buf =3D buffer;
+		} else {
+			spi_xfer.tx_buf =3D buffer;
+			spi_xfer.rx_buf =3D NULL;
 		}
-	}
 =

-	spi_xfer.cs_change =3D 0;
-	spi_xfer.len =3D len;
+		spi_message_init(&m);
+		spi_message_add_tail(&spi_xfer, &m);
+		ret =3D spi_sync_locked(phy->spi_device, &m);
+		if (ret < 0)
+			goto exit;
 =

-	if (direction) {
-		spi_xfer.tx_buf =3D NULL;
-		spi_xfer.rx_buf =3D buffer;
-	} else {
-		spi_xfer.tx_buf =3D buffer;
-		spi_xfer.rx_buf =3D NULL;
+		len -=3D transfer_len;
+		buffer +=3D transfer_len;
 	}
 =

-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
-	ret =3D spi_sync_locked(phy->spi_device, &m);
-
 exit:
 	spi_bus_unlock(phy->spi_device->master);
 	return ret;
--
2.7.4




------------------------------

Message: 2
Date: Thu, 16 Feb 2017 16:08:21 +0000
From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [tpmdd-devel] [PATCH 0/5] Fix whole native SPI TPM driver
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Peter	Huewe
	<peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Message-ID:
	<1487261306-2494-1-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Content-Type: text/plain

During our testing it showed that unfortunately the whole native spi tpm dr=
iver
was more or less non-functional since it was merged, e.g. the wrong byte for
waitstate handling was used and transfers larger than 64 bytes did not work=
 at all.

This was probably caused by the merging of the different approaches back th=
en,
as the initial RFC patch did not have these problems, and also my sudden la=
ck
of time/commitment back then.
I'm sorry that the final driver code went untested for that long time.

This patch set fixes these issues one by one.
In order to avoid duplication the read/write function was consolidated to o=
ne
transfer function, so we do not have to apply the same fix at two locations.
Maybe consider squashing it - we splitted it for easier review.
 =

Affected Kernels: 4.8, 4.9, 4.10
Patchset was tested on Raspberry Pi2 with SLB9670 (TPM1.2 and TPM2.0)

Peter Huewe (5):
  tpm_tis_spi: Use single function to transfer data
  tpm_tis_spi: Abort transfer when too many wait states are signaled
  tpm_tis_spi: Check correct byte for wait state indicator
  tpm_tis_spi: Remove limitation of transfers to MAX_SPI_FRAMESIZE bytes
  tpm_tis_spi: Add small delay after last transfer

 drivers/char/tpm/tpm_tis_spi.c | 163 +++++++++++++++++--------------------=
----
 1 file changed, 69 insertions(+), 94 deletions(-)

-- =

2.7.4




------------------------------

Message: 3
Date: Thu, 16 Feb 2017 16:08:22 +0000
From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [tpmdd-devel] [PATCH 1/5] tpm_tis_spi: Use single function to
	transfer data
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,	Christophe Ricard
	<christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Peter	Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>,
	Alexander
Message-ID:
	<1487261306-2494-2-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Content-Type: text/plain

The algorithm for sending data to the TPM is mostly identical to the
algorithm for receiving data from the TPM, so a single function is
sufficient to handle both cases.

This is a prequisite for all the other fixes, so we don't have to fix
everything twice (send/receive)

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
[prerequisite for other fixes in this series]
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 87 ++++++++++++--------------------------=
----
 1 file changed, 24 insertions(+), 63 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 5292e5768a7e..6e1a3c43f621 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -47,8 +47,8 @@ struct tpm_tis_spi_phy {
 	struct tpm_tis_data priv;
 	struct spi_device *spi_device;
 =

-	u8 tx_buf[MAX_SPI_FRAMESIZE + 4];
-	u8 rx_buf[MAX_SPI_FRAMESIZE + 4];
+	u8 tx_buf[4];
+	u8 rx_buf[4];
 };
 =

 static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_da=
ta *data)
@@ -56,8 +56,8 @@ static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(=
struct tpm_tis_data *da
 	return container_of(data, struct tpm_tis_spi_phy, priv);
 }
 =

-static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
-				  u16 len, u8 *result)
+static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 le=
n,
+				u8 *buffer, u8 direction)
 {
 	struct tpm_tis_spi_phy *phy =3D to_tpm_tis_spi_phy(data);
 	int ret, i;
@@ -66,17 +66,17 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data *=
data, u32 addr,
 		.tx_buf =3D phy->tx_buf,
 		.rx_buf =3D phy->rx_buf,
 		.len =3D 4,
+		.cs_change =3D 1,
 	};
 =

 	if (len > MAX_SPI_FRAMESIZE)
 		return -ENOMEM;
 =

-	phy->tx_buf[0] =3D 0x80 | (len - 1);
+	phy->tx_buf[0] =3D direction | (len - 1);
 	phy->tx_buf[1] =3D 0xd4;
-	phy->tx_buf[2] =3D (addr >> 8)  & 0xFF;
-	phy->tx_buf[3] =3D addr	      & 0xFF;
+	phy->tx_buf[2] =3D addr >> 8;
+	phy->tx_buf[3] =3D addr;
 =

-	spi_xfer.cs_change =3D 1;
 	spi_message_init(&m);
 	spi_message_add_tail(&spi_xfer, &m);
 =

@@ -85,7 +85,7 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data *da=
ta, u32 addr,
 	if (ret < 0)
 		goto exit;
 =

-	memset(phy->tx_buf, 0, len);
+	phy->tx_buf[0] =3D 0;
 =

 	/* According to TCG PTP specification, if there is no TPM present at
 	 * all, then the design has a weak pull-up on MISO. If a TPM is not
@@ -103,7 +103,14 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data =
*data, u32 addr,
 =

 	spi_xfer.cs_change =3D 0;
 	spi_xfer.len =3D len;
-	spi_xfer.rx_buf =3D result;
+
+	if (direction) {
+		spi_xfer.tx_buf =3D NULL;
+		spi_xfer.rx_buf =3D buffer;
+	} else {
+		spi_xfer.tx_buf =3D buffer;
+		spi_xfer.rx_buf =3D NULL;
+	}
 =

 	spi_message_init(&m);
 	spi_message_add_tail(&spi_xfer, &m);
@@ -114,62 +121,16 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data=
 *data, u32 addr,
 	return ret;
 }
 =

+static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
+				  u16 len, u8 *result)
+{
+	return tpm_tis_spi_transfer(data, addr, len, result, 0x80);
+}
+
 static int tpm_tis_spi_write_bytes(struct tpm_tis_data *data, u32 addr,
 				   u16 len, u8 *value)
 {
-	struct tpm_tis_spi_phy *phy =3D to_tpm_tis_spi_phy(data);
-	int ret, i;
-	struct spi_message m;
-	struct spi_transfer spi_xfer =3D {
-		.tx_buf =3D phy->tx_buf,
-		.rx_buf =3D phy->rx_buf,
-		.len =3D 4,
-	};
-
-	if (len > MAX_SPI_FRAMESIZE)
-		return -ENOMEM;
-
-	phy->tx_buf[0] =3D len - 1;
-	phy->tx_buf[1] =3D 0xd4;
-	phy->tx_buf[2] =3D (addr >> 8)  & 0xFF;
-	phy->tx_buf[3] =3D addr         & 0xFF;
-
-	spi_xfer.cs_change =3D 1;
-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
-
-	spi_bus_lock(phy->spi_device->master);
-	ret =3D spi_sync_locked(phy->spi_device, &m);
-	if (ret < 0)
-		goto exit;
-
-	memset(phy->tx_buf, 0, len);
-
-	/* According to TCG PTP specification, if there is no TPM present at
-	 * all, then the design has a weak pull-up on MISO. If a TPM is not
-	 * present, a pull-up on MISO means that the SB controller sees a 1,
-	 * and will latch in 0xFF on the read.
-	 */
-	for (i =3D 0; (phy->rx_buf[0] & 0x01) =3D=3D 0 && i < TPM_RETRY; i++) {
-		spi_xfer.len =3D 1;
-		spi_message_init(&m);
-		spi_message_add_tail(&spi_xfer, &m);
-		ret =3D spi_sync_locked(phy->spi_device, &m);
-		if (ret < 0)
-			goto exit;
-	}
-
-	spi_xfer.len =3D len;
-	spi_xfer.tx_buf =3D value;
-	spi_xfer.cs_change =3D 0;
-	spi_xfer.tx_buf =3D value;
-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
-	ret =3D spi_sync_locked(phy->spi_device, &m);
-
-exit:
-	spi_bus_unlock(phy->spi_device->master);
-	return ret;
+	return tpm_tis_spi_transfer(data, addr, len, value, 0);
 }
 =

 static int tpm_tis_spi_read16(struct tpm_tis_data *data, u32 addr, u16 *re=
sult)
-- =

2.7.4




------------------------------

Message: 4
Date: Thu, 16 Feb 2017 16:08:23 +0000
From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [tpmdd-devel] [PATCH 2/5] tpm_tis_spi: Abort transfer when
	too many	wait states are signaled
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,	Christophe Ricard
	<christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Peter	Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>,
	Alexander
Message-ID:
	<1487261306-2494-3-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Content-Type: text/plain

Abort the transfer with ETIMEDOUT when the TPM signals more than
TPM_RETRY wait states. Continuing with the transfer in this state
will only lead to arbitrary failures in other parts of the code.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 6e1a3c43f621..d782b9974c14 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -101,6 +101,11 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *d=
ata, u32 addr, u8 len,
 			goto exit;
 	}
 =

+	if (i =3D=3D TPM_RETRY) {
+		ret =3D -ETIMEDOUT;
+		goto exit;
+	}
+
 	spi_xfer.cs_change =3D 0;
 	spi_xfer.len =3D len;
 =

-- =

2.7.4




------------------------------

Message: 5
Date: Thu, 16 Feb 2017 16:08:24 +0000
From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [tpmdd-devel] [PATCH 3/5] tpm_tis_spi: Check correct byte for
	wait	state indicator
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,	Christophe Ricard
	<christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Peter	Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>,
	Alexander
Message-ID:
	<1487261306-2494-4-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Content-Type: text/plain

Wait states are signaled in the last byte received from the TPM in
response to the header, not the first byte. Check rx_buf[3] instead of
rx_buf[0].

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 40 +++++++++++++++++++++-----------------=
--
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index d782b9974c14..16938e2253d2 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -60,7 +60,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data=
, u32 addr, u8 len,
 				u8 *buffer, u8 direction)
 {
 	struct tpm_tis_spi_phy *phy =3D to_tpm_tis_spi_phy(data);
-	int ret, i;
+	int ret;
 	struct spi_message m;
 	struct spi_transfer spi_xfer =3D {
 		.tx_buf =3D phy->tx_buf,
@@ -85,25 +85,27 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *da=
ta, u32 addr, u8 len,
 	if (ret < 0)
 		goto exit;
 =

-	phy->tx_buf[0] =3D 0;
-
-	/* According to TCG PTP specification, if there is no TPM present at
-	 * all, then the design has a weak pull-up on MISO. If a TPM is not
-	 * present, a pull-up on MISO means that the SB controller sees a 1,
-	 * and will latch in 0xFF on the read.
-	 */
-	for (i =3D 0; (phy->rx_buf[0] & 0x01) =3D=3D 0 && i < TPM_RETRY; i++) {
-		spi_xfer.len =3D 1;
-		spi_message_init(&m);
-		spi_message_add_tail(&spi_xfer, &m);
-		ret =3D spi_sync_locked(phy->spi_device, &m);
-		if (ret < 0)
+	if ((phy->rx_buf[3] & 0x01) =3D=3D 0) {
+		// handle SPI wait states
+		int i;
+
+		phy->tx_buf[0] =3D 0;
+
+		for (i =3D 0; i < TPM_RETRY; i++) {
+			spi_xfer.len =3D 1;
+			spi_message_init(&m);
+			spi_message_add_tail(&spi_xfer, &m);
+			ret =3D spi_sync_locked(phy->spi_device, &m);
+			if (ret < 0)
+				goto exit;
+			if (phy->rx_buf[0] & 0x01)
+				break;
+		}
+
+		if (i =3D=3D TPM_RETRY) {
+			ret =3D -ETIMEDOUT;
 			goto exit;
-	}
-
-	if (i =3D=3D TPM_RETRY) {
-		ret =3D -ETIMEDOUT;
-		goto exit;
+		}
 	}
 =

 	spi_xfer.cs_change =3D 0;
-- =

2.7.4




------------------------------

Message: 6
Date: Thu, 16 Feb 2017 16:09:46 +0000
From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [tpmdd-devel] [PATCH 5/5] tpm_tis_spi: Add small delay after
	last	transfer
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,	Christophe Ricard
	<christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Peter	Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>,
	Alexander
Message-ID:
	<1487261386-2641-5-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Content-Type: text/plain

Testing the implementation with a Raspberry Pi 2 showed that under some
circumstances its SPI master erroneously releases the CS line before the
transfer is complete, i.e. before the end of the last clock. In this case
the TPM ignores the transfer and misses for example the GO command. The
driver is unable to detect this communication problem and will wait for a
command response that is never going to arrive, timing out eventually.

As a workaround, the small delay ensures that the CS line is held long
enough, even with a faulty SPI master. Other SPI masters are not affected,
except for a negligible performance penalty.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index b50c5b072df3..685c51bf5d7e 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -110,6 +110,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *da=
ta, u32 addr, u8 len,
 =

 		spi_xfer.cs_change =3D 0;
 		spi_xfer.len =3D transfer_len;
+		spi_xfer.delay_usecs =3D 5;
 =

 		if (direction) {
 			spi_xfer.tx_buf =3D NULL;
-- =

2.7.4




------------------------------

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot

------------------------------

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel


End of tpmdd-devel Digest, Vol 110, Issue 19
********************************************

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
